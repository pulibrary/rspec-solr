require 'spec_helper'
require 'rspec-solr'

describe RSpecSolr do
  
  # fixtures below
  
  context "#include().in_first(n)" do
    context "should include().in_first(n)" do
      it "passes when include arg is String and doc meets criteria" do
        @solr_resp_5_docs.should include("222").in_first(3)
        @solr_resp_5_docs.should include("111").in_first(1)
        @solr_resp_5_docs.should include("222").in_first(2)
      end
      it "fails when include arg is String but doc comes too late" do
        lambda {
          @solr_resp_5_docs.should include("222").in_first(1)
        }.should fail_matching('expected response to include document "222" in first 1')
      end
      it "passes when include arg is Hash and doc meets criteria" do
        @solr_resp_5_docs.should include("fld" => ["val1", "val2", "val3"]).in_first(4)
      end
      it "fails when include arg is Hash but doc comes too late" do
        lambda {
          @solr_resp_5_docs.should include("fld" => ["val1", "val2", "val3"]).in_first(2)
        }.should fail_matching('expected response to include document {"fld"=>["val1", "val2", "val3"]} in first 2')
      end
      it "passes when include arg is Array and all docs meet criteria" do
        @solr_resp_5_docs.should include(["111", "222"]).in_first(2)
        @solr_resp_5_docs.should include(["333", {"fld2"=>"val2"}]).in_first(4)
      end
      it "fails when include arg is Array but at least one doc comes too late" do
        lambda {
          @solr_resp_5_docs.should include(["111", "444"]).in_first(2)
        }.should fail_matching('expected response to include documents ["111", "444"] in first 2')
        lambda {
          @solr_resp_5_docs.should include(["333", {"fld2"=>"val2"}]).in_first(2)
        }.should fail_matching('expected response to include documents ["333", {"fld2"=>"val2"}] in first 2')
      end
      it "fails when there is no matching result" do
        lambda {        
          @solr_resp_5_docs.should include("666").in_first(6)
        }.should fail_matching('expected response to include document "666" in first 6')
        lambda {
          @solr_resp_5_docs.should include("fld"=>"not there").in_first(3)
        }.should fail_matching('expected response to include document {"fld"=>"not there"} in first 3')
        lambda {
          @solr_resp_5_docs.should include("666", "777").in_first(6)
        }.should fail_matching('expected response to include documents "666" and "777" in first 6')
      end
    end # should include().in_first(n)

    context "should_NOT include().in_first(n)" do
      it "fails when include arg is String and doc meets criteria" do
        lambda {
          @solr_resp_5_docs.should_not include("222").in_first(2)
        }.should fail_matching('not to include document "222" in first 2')
      end
      it "passes when include arg is String but doc comes too late" do
        @solr_resp_5_docs.should_not include("222").in_first(1)
      end
      it "fails when include arg is Hash and doc meets criteria" do
        lambda {
          @solr_resp_5_docs.should_not include("fld" => ["val1", "val2", "val3"]).in_first(4)
        }.should fail_matching('not to include document {"fld"=>["val1", "val2", "val3"]} in first 4')
      end
      it "passes when include arg is Hash but doc comes too late" do
        @solr_resp_5_docs.should_not include("fld" => ["val1", "val2", "val3"]).in_first(2)
      end
      it "fails when include arg is Array and all docs meet criteria" do
        lambda {
          @solr_resp_5_docs.should_not include("111", "222").in_first(2)
        }.should fail_matching('not to include documents "111" and "222" in first 2')
        lambda {
          @solr_resp_5_docs.should_not include(["333", {"fld2"=>"val2"}]).in_first(4)
        }.should fail_matching('not to include documents ["333", {"fld2"=>"val2"}] in first 4')
      end
      it "passes when include arg is Array but at least one doc comes too late" do
        @solr_resp_5_docs.should_not include(["111", "444"]).in_first(2)
        @solr_resp_5_docs.should_not include(["333", {"fld2"=>"val2"}]).in_first(2)
      end
      it "passes when there is no matching result" do
        @solr_resp_5_docs.should_not include("666").in_first(6)
        @solr_resp_5_docs.should_not include("fld"=>"not there").in_first(3)
        @solr_resp_5_docs.should_not include("666", "777").in_first(6)
      end      
    end # should_NOT include().in_first(n)    
  end # include().in_first(n)
  
  context "#include().in_first (no n set) implies n=1" do
    context "should #include().in_first" do
      it "passes when matching document is first" do
        @solr_resp_5_docs.should include("111").in_first
      end
      it "fails when matching document is not first" do
        lambda {
          @solr_resp_5_docs.should include("fld"=>["val1", "val2", "val3"]).in_first
        }.should fail_matching('expected response to include document {"fld"=>["val1", "val2", "val3"]} in first 1')
      end
    end
    context "should_NOT include().in_first" do
      it "fails when matching document is first" do
        lambda {
          @solr_resp_5_docs.should_not include("111").in_first
        }.should fail_matching('not to include document "111" in first 1')
      end
      it "passes when matching document is not first" do
        @solr_resp_5_docs.should_not include("fld"=>["val1", "val2", "val3"]).in_first
      end
    end
  end # include().in_first (no n set)
  
  context "#include().in_first(n).allowed_chained.names" do
    context "should #include().in_first(n).allowed_chained.names" do
      it "passes when document(s) meet criteria" do
        @solr_resp_5_docs.should include("222").in_first(2).results
        @solr_resp_5_docs.should include("222").in_first(2).documents
        @solr_resp_5_docs.should include("fld2"=>"val2").in_first.document
      end
      it "fails when document(s) don't meet criteria" do
        lambda {
          @solr_resp_5_docs.should include("fld"=>["val1", "val2", "val3"]).in_first.result
        }.should fail_matching('expected response to include document {"fld"=>["val1", "val2", "val3"]} in first 1')
      end
    end
    context "should_NOT #include().in_first(n).allowed_chained.names" do
      it "fails when document(s) meet criteria" do
        lambda {
          @solr_resp_5_docs.should_not include("222").in_first(2).documents
        }.should fail_matching('not to include document "222" in first 2 ')
        lambda {
          @solr_resp_5_docs.should_not include("fld2"=>"val2").in_first.document
        }.should fail_matching('not to include document {"fld2"=>"val2"} in first 1')
      end
      it "passes when document(s) don't meet criteria" do
        @solr_resp_5_docs.should_not include("fld"=>["val1", "val2", "val3"]).in_first.result
      end
    end
    it "should raise a NoMethodError exception when it gets nonsense after include" do
      expect {
        @solr_resp.should include("111").bad_method(2)
      }.to raise_error(NoMethodError, /bad_method/)
    end    
  end # include().in_first().allowed_chained.names
  
  context "#include().as_first" do
    context "should include().as_first" do
      it "passes when the first document meets the criteria" do
        @solr_resp_5_docs.should include("111").as_first
        @solr_resp_5_docs.should include("fld"=>"val").as_first
        @solr_resp_5_docs.should include("fld"=>"val", "fld2"=>"val2").as_first
      end
      it "fails when a document meets the criteria but is not the first" do
        lambda {
          @solr_resp_5_docs.should include("222").as_first
        }.should fail_matching('expected response to include document "222" in first 1')
        lambda {
          @solr_resp_5_docs.should include("fld" => ["val1", "val2", "val3"]).as_first
          }.should fail_matching('expected response to include document {"fld"=>["val1", "val2", "val3"]} in first 1')
      end
      it "fails when there is no matching result" do
        lambda {
          @solr_resp_5_docs.should include("96").as_first
          }.should fail_matching('expected response to include document "96" in first 1')
      end    
    end
    context "should_NOT include().as_first" do
      it "fails when the first document meets the criteria" do
        lambda {
          @solr_resp_5_docs.should_not include("111").as_first
        }.should fail_matching('not to include document "111" in first 1')
        lambda {
          @solr_resp_5_docs.should_not include("fld"=>"val").as_first
        }.should fail_matching('not to include document {"fld"=>"val"} in first 1')
        lambda {
          @solr_resp_5_docs.should_not include("fld"=>"val", "fld2"=>"val2").as_first
        }.should fail_matching('not to include document {"fld"=>"val", "fld2"=>"val2"} in first 1')
      end
      it "passes when a document meets the criteria but is not the first" do
        @solr_resp_5_docs.should_not include("222").as_first.document
        @solr_resp_5_docs.should_not include("fld" => ["val1", "val2", "val3"]).as_first
      end
      it "passes when there is no matching result" do
        @solr_resp_5_docs.should_not include("96").as_first
      end    
    end
  end
  
  
  context "#include().as_first().allowed_chained.names" do
    context "should #include().as_first(n).allowed_chained.names" do
      it "passes when document(s) meet criteria" do
        @solr_resp_5_docs.should include(["111", "222"]).as_first(2).results
        @solr_resp_5_docs.should include(["111", "222"]).as_first(2).documents
        @solr_resp_5_docs.should include("fld2"=>"val2").as_first.document
      end
      it "fails when document(s) don't meet criteria" do
        lambda {
          @solr_resp_5_docs.should include("fld"=>["val1", "val2", "val3"]).as_first.result
        }.should fail_matching ('expected response to include document {"fld"=>["val1", "val2", "val3"]} in first 1')
      end
    end
    context "should_NOT #include().as_first(n).any_chained.names" do
      it "fails when document(s) meet criteria" do
        lambda {
          @solr_resp_5_docs.should_not include(["111", "222"]).as_first(2).documents
        }.should fail_matching('not to include documents ["111", "222"] in first 2')
        lambda {
          @solr_resp_5_docs.should_not include("fld2"=>"val2").as_first.document
        }.should fail_matching('not to include document {"fld2"=>"val2"} in first 1')
      end
      it "passes when document(s) don't meet criteria" do
        @solr_resp_5_docs.should_not include("fld"=>["val1", "val2", "val3"]).as_first.result
      end
    end
  end # include().as_first().allowed_chained.names

  before(:all) do
    @solr_resp_5_docs = RSpecSolr::SolrResponseHash.new({ "response" =>
                          { "numFound" => 5, 
                            "start" => 0, 
                            "docs" => 
                              [ {"id"=>"111", "fld"=>"val", "fld2"=>"val2"}, 
                                {"id"=>"222"}, 
                                {"id"=>"333", "fld"=>"val"}, 
                                {"id"=>"444", "fld"=>["val1", "val2", "val3"]}, 
                                {"id"=>"555"}
                              ]
                          }
                        })
  end
  
end