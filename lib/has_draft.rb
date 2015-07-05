module HasDraft
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def has_draft(options = {}, &block)
      return if self.included_modules.include?(HasDraft::InstanceMethods)
      include HasDraft::InstanceMethods
      
      cattr_accessor :draft_class_name, :draft_foreign_key, :draft_table_name, :draft_columns
      
      self.draft_class_name = options[:class_name]  || 'Draft'
      self.draft_foreign_key = options[:foreign_key] || self.to_s.foreign_key
      self.draft_table_name = options[:table_name]  || "#{table_name_prefix}#{base_class.name.demodulize.underscore}_drafts#{table_name_suffix}"
      
      # Create Relationship to Draft Copy
      class_eval do
        has_one :draft, :class_name => "#{self.to_s}::#{draft_class_name}",
                        :foreign_key => draft_foreign_key,
                        :dependent => :destroy
        
        scope :with_draft, lambda { includes(:draft).where("#{draft_table_name}.id IS NOT NULL").references(draft_table_name) }
        scope :without_draft, lambda { includes(:draft).where("#{draft_table_name}.id IS NULL").references(draft_table_name) }
      end

      # Default parent class to ActiveRecord::Base
      options[:extends] = ActiveRecord::Base if options[:extends].nil?

      # Dynamically Create Model::Draft Class
      const_set(draft_class_name, Class.new(options[:extends]))
      
      draft_class.cattr_accessor :original_class
      draft_class.original_class = self
      draft_class.table_name = draft_table_name

      # Default parent association
      options[:belongs_to] = self.to_s.demodulize.underscore.to_sym if options[:belongs_to].nil?

      # Draft Parent Association
      draft_class.belongs_to options[:belongs_to], :class_name  => "::#{self.to_s}", :foreign_key => draft_foreign_key
      
      # Block extension
      draft_class.class_eval(&block) if block_given?
      
      # Finally setup which columns to draft
      self.draft_columns = draft_class.new.attributes.keys - [draft_class.primary_key, draft_foreign_key, 'created_at', 'updated_at', inheritance_column]
    end
    
    def draft_class
      const_get(draft_class_name)
    end
  end
  
  module InstanceMethods
    def has_draft?
      !self.draft.nil?
    end
    
    def save_to_draft(perform_validation = true)
      return false if perform_validation and !self.valid?
      
      instantiate_draft! unless has_draft?
      copy_attributes_to_draft
      
      self.draft.save(perform_validation)
      self.reload
    end
    
    def instantiate_draft
      self.build_draft
      
      copy_attributes_to_draft
      before_instantiate_draft
      
      self.draft.tap(&:save)
    end
    
    def instantiate_draft!
      instantiate_draft do |draft|
        draft.save unless self.new_record?
      end
    end
    
    def copy_attributes_to_draft
      self.class.draft_columns.each do |attribute|
        self.draft.send("#{attribute}=", send(attribute))
      end
      self
    end
    
    def copy_attributes_from_draft
      self.class.draft_columns.each do |attribute|
        self.send("#{attribute}=", self.draft.send(attribute))
      end
      self
    end
    
    def before_instantiate_draft
    end
    
    def replace_with_draft!
      copy_attributes_from_draft
      
      before_replace_with_draft
      
      self.save unless self.new_record?
      self
    end
    
    def before_replace_with_draft
    end
    
    def destroy_draft!
      before_destroy_draft
      
      self.draft.destroy if self.draft
      self.draft(true)
    end
    
    def before_destroy_draft
    end
  end
end

require "has_draft/railtie"
