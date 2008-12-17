require File.join(File.dirname(__FILE__), 'test_helper')
require File.join(File.dirname(__FILE__), 'models/article')

class ArticleTest < Test::Unit::TestCase
  fixtures :articles, :article_drafts
  set_fixture_class :article_drafts => Article::Draft
  
  context "Article model" do
    should_have_one :draft
    should_have_named_scope :with_draft
    should_have_named_scope :without_draft
    
    should_have_class_methods :draft_class_name, :draft_foreign_key, :draft_table_name
    
    should "default class name to Draft" do
      assert_equal "Draft", Article.draft_class_name
    end
    
    should "expose draft class constant" do
      assert_equal Article::Draft, Article.draft_class
    end
    
    should "default foreign key to article_id" do
      assert_equal "article_id", Article.draft_foreign_key
    end
    
    should "default table name to article_drafts" do
      assert_equal "article_drafts", Article.draft_table_name
    end
    
    context "Draft model" do
      should "have a be defined under Article" do
        assert Article.constants.include?('Draft')
      end

      should "load" do
        assert_nothing_raised do
          Article::Draft
        end
      end
      
      should "expose original class name of Article" do
        assert_equal Article, Article::Draft.original_class
      end
    end
  end
  
  context "an article" do
    setup { @article = articles(:article_without_draft) }
    
    context "when instantiating a new draft" do
      setup { @article.instantiate_draft! }
      
      should "create draft" do
        assert_not_nil @article.draft
        assert !@article.draft.new_record?
      end
      
      should "copy draft fields" do
        Article.draft_columns.each do |column|
          assert_equal @article.send(column), @article.draft.send(column)
        end
      end
    end
    
    context "when destroying an existing draft" do
      setup do
        @article = articles(:article_with_draft)
        @article.destroy_draft!
      end
      
      should "destroy associated draft" do
        assert_nil @article.draft
      end
    end
    
    context "when replacing with draft" do
      setup do
        @article = articles(:article_with_draft)
        @article.replace_with_draft!
      end
      
      should "still have draft" do
        assert_not_nil @article.draft
      end
      
      should "now have the same field values as draft" do
        Article.draft_columns.each do |column|
          assert_equal @article.send(column), @article.draft.send(column)
        end
      end
    end
    
  end
  
end
