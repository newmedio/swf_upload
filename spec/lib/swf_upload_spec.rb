require File.dirname(__FILE__) + '/../spec_helper'
describe SwfUpload do
  describe :responds_to_swf_upload do
    it "should get added to a class that includes SwfUpload" do
      test_controller = TestController.new
      test_controller.class.should_not respond_to(:responds_to_swf_upload)
      TestController.send(:include, SwfUpload)
      test_controller.class.should respond_to(:responds_to_swf_upload)
    end

    it "should be available in ApplicationController" do
      ApplicationController.should respond_to(:responds_to_swf_upload)
    end

    it "should turn off cookie only" do
      TestController.should_receive(:session).with do |hash|
        hash[:cookie_only].should == false 
        hash[:other].should == :stuff
      end
      TestController.class_eval do
        responds_to_swf_upload( :other => :stuff )
      end
    end

    it "should set the mime type based off the file extension if it is 'application/octet-stream'" do
      # prolly have to do this in an integration test...

    end
  end
end
