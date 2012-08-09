require 'spec_helper'
require 'rspec-solr'

describe RSpecSolr do

  # fixtures at end of this file

  context "should have(n)_documents" do
    
    it "pluralizes 'documents'" do
      @solr_resp_1_doc.should have(1).document
    end
    
    it "passes if target response has n documents" do
      @solr_resp_5_docs.should have(5).documents
      @solr_resp_no_docs.should have(0).documents
    end
    
    it "converts :no to 0" do
      @solr_resp_no_docs.should have(:no).documents
    end
    
    it "converts a String argument to Integer" do
      @solr_resp_5_docs.should have('5').documents
    end
    
    it "fails if target response has < n documents" do
      lambda {
        @solr_resp_5_docs.should have(6).documents
      }.should fail_with("expected 6 documents, got 5")
      lambda {
        @solr_resp_no_docs.should have(1).document
      }.should fail_with("expected 1 document, got 0")
    end
    
    it "fails if target response has > n documents" do
      lambda {
        @solr_resp_5_docs.should have(4).documents
      }.should fail_with("expected 4 documents, got 5")
      lambda {
        @solr_resp_1_doc.should have(0).documents
      }.should fail_with("expected 0 documents, got 1")
    end
    
  end
  
  context "should_not have(n).documents" do
    it "passes if target response has < n documents" do
      @solr_resp_5_docs.should_not have(6).documents
      @solr_resp_1_doc.should_not have(2).documents
      @solr_resp_no_docs.should_not have(1).document
    end
    
    it "passes if target response has > n documents" do
      @solr_resp_5_docs.should_not have(4).documents
      @solr_resp_1_doc.should_not have(0).documents
      @solr_resp_no_docs.should_not have(-1).documents
    end
    
    it "fails if target response has n documents" do
      lambda {
        @solr_resp_5_docs.should_not have(5).documents
      }.should fail_with("expected target not to have 5 documents, got 5")
    end
  end
  
  context "should have_exactly(n).documents" do
    it "passes if target response has n documents" do
      @solr_resp_5_docs.should have_exactly(5).documents
      @solr_resp_no_docs.should have_exactly(0).documents
    end
    it "converts :no to 0" do
      @solr_resp_no_docs.should have_exactly(:no).documents
    end
    it "fails if target response has < n documents" do
      lambda {
        @solr_resp_5_docs.should have_exactly(6).documents
      }.should fail_with("expected 6 documents, got 5")
      lambda {
        @solr_resp_no_docs.should have_exactly(1).document
      }.should fail_with("expected 1 document, got 0")
    end
    
    it "fails if target response has > n documents" do
      lambda {
        @solr_resp_5_docs.should have_exactly(4).documents
      }.should fail_with("expected 4 documents, got 5")
      lambda {
        @solr_resp_1_doc.should have_exactly(0).documents
      }.should fail_with("expected 0 documents, got 1")
    end
  end
  
  context "should have_at_least(n).documents" do
    it "passes if target response has n documents" do
      @solr_resp_5_docs.should have_at_least(5).documents
      @solr_resp_1_doc.should have_at_least(1).document
      @solr_resp_no_docs.should have_at_least(0).documents
    end
    
    it "passes if target response has > n documents" do
      @solr_resp_5_docs.should have_at_least(4).documents
      @solr_resp_1_doc.should have_at_least(0).documents
    end
    
    it "fails if target response has < n documents" do
      lambda {
        @solr_resp_5_docs.should have_at_least(6).documents
      }.should fail_matching("expected at least 6 documents, got 5")
      lambda {
        @solr_resp_no_docs.should have_at_least(1).document
      }.should fail_matching("expected at least 1 document, got 0")
    end
    
    it "provides educational negative failure messages" do
      # given
      my_matcher = have_at_least(6).documents
      # when
      my_matcher.matches?(@solr_resp_5_docs)
      # then 
      my_matcher.failure_message_for_should_not.should eq <<-EOF
Isn't life confusing enough?
Instead of having to figure out the meaning of this:
  should_not have_at_least(6).documents
We recommend that you use this instead:
  should have_at_most(5).documents
EOF
    end
  end
    
  context "should have_at_most(n).documents" do
    it "passes if target response has n documents" do
      @solr_resp_5_docs.should have_at_most(5).documents
      @solr_resp_1_doc.should have_at_most(1).document
      @solr_resp_no_docs.should have_at_most(0).documents
    end

    it "passes if target response has < n documents" do
      @solr_resp_5_docs.should have_at_most(6).documents
      @solr_resp_no_docs.should have_at_most(1).document
    end

    it "fails if target response has > n documents" do
      lambda {
        @solr_resp_5_docs.should have_at_most(4).documents
      }.should fail_matching("expected at most 4 documents, got 5")
      lambda {
        @solr_resp_1_doc.should have_at_most(0).documents
      }.should fail_matching("expected at most 0 documents, got 1")
    end

    it "provides educational negative failure messages" do
      # given
      my_matcher = have_at_most(4).documents
      # when
      my_matcher.matches?(@solr_resp_5_docs)
      # then 
      my_matcher.failure_message_for_should_not.should eq <<-EOF
Isn't life confusing enough?
Instead of having to figure out the meaning of this:
  should_not have_at_most(4).documents
We recommend that you use this instead:
  should have_at_least(5).documents
EOF
    end
  end
  
  before(:all) do
    @solr_resp_1_doc = RSpecSolr::SolrResponseHash.new({ "response" =>
                          { "numFound" => 5, 
                            "start" => 0, 
                            "docs" => [ {"id"=>"111"} ]
                          }
                        })

    @solr_resp_5_docs = RSpecSolr::SolrResponseHash.new({ "response" =>
                          { "numFound" => 5, 
                            "start" => 0, 
                            "docs" => 
                              [ {"id"=>"111"}, 
                                {"id"=>"222"}, 
                                {"id"=>"333"}, 
                                {"id"=>"444"}, 
                                {"id"=>"555"}
                              ]
                          }
                        })

    @solr_resp_no_docs = RSpecSolr::SolrResponseHash.new({ "response" =>
                          { "numFound" => 0, 
                            "start" => 0, 
                            "docs" => [] 
                          }
                        }) 
  end
  
end