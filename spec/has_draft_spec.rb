require "spec_helper"

describe HasDraft do
  before(:all) do
    ActiveSupport::Deprecation.silenced = true
  end

  context "Model with has_draft" do
    it "should expose #draft_class_name as Draft" do
      Article.draft_class_name.should == "Draft"
    end
    
    it "should expose #draft_class as Article::Draft" do
      Article.draft_class.should == Article::Draft
    end
    
    it "should default #draft_foreign_key as article_id" do
      Article.draft_foreign_key.should == "article_id"
    end
    
    it "should default #draft_table_name as article_drafts" do
      Article.draft_table_name.should == "article_drafts"
    end
    
    it "should expose #with_draft and #without_draft scopes" do
      expect { Article.with_draft.to_a }.to_not raise_error
      expect { Article.without_draft.to_a }.to_not raise_error
    end
    
    describe "Draft Model" do
      it "should be defined under the Article namespace" do
        Article.constants.map(&:to_s).should include('Draft')
      end
      
      it "should expose #original_class as Article" do
        Article::Draft.original_class.should == Article
      end
    end
  end
  
  context "an article" do
    before { @article = Factory.create(:article) }
    
    context "when instantiating a new draft" do
      before { @article.instantiate_draft! }
      
      it "should create draft" do
        @article.draft.should_not be_nil
        @article.draft.should_not be_new_record
      end
      
      it "should copy draft fields" do
        Article.draft_columns.each do |column|
          @article.send(column).should == @article.draft.send(column)
        end
      end
    end
    
    context "when destroying an existing draft" do
      before do
        @article = Factory.create(:article_with_draft)
        @article.destroy_draft!
      end
      
      it "should associated draft" do
        @article.draft.should be_nil
      end
    end
    
    context "when replacing with draft" do
      before do
        @article = Factory.create(:article_with_draft)
        @article.replace_with_draft!
      end
      
      it "should still have draft" do
        @article.draft.should_not be_nil
      end
      
      it "should now have the same field values as draft" do
        Article.draft_columns.each do |column|
          @article.send(column).should == @article.draft.send(column)
        end
      end
    end
  end

  context "Draft class extends" do

    it "ActiveRecord::Base when no options are passed" do
      Article::Draft.superclass.should == ActiveRecord::Base
    end

    it "the class passed in with the :extends option" do
      BlogPost::Draft.superclass.should == Post
    end
  end

  context "Draft class belongs to" do

    it "self when :belongs_to is not specified" do
      Article::Draft.reflect_on_association(:article).macro.should == :belongs_to
    end

    it "the model passed in with the :belongs_to option" do
      BlogPost::Draft.reflect_on_association(:post).macro.should == :belongs_to
    end
  end
  
end
