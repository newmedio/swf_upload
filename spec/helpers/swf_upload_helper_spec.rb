require File.dirname(__FILE__) + '/../spec_helper'
describe SwfUploadHelper do
  describe :include_swf_upload do
    it do
      helper.should respond_to(:include_swf_upload)
    end
    it do
      helper.include_swf_upload.should be_an_instance_of(String)
    end
    # there isn't any logic here, so...
    it "should include a bunch of javascript files and a css file"
  end
  
  describe :swf_upload_tag do
    before do
      helper.output_buffer = '' # wouldn't empty string make a good default?
      helper.instance_variable_set(:@template, helper ) # i probably shouldn't have to do this.
      helper.send(:session).session_id = '12345'
      helper.should_receive(:request).and_return( @session_options = mock('session options'))
    end
    describe "establish session through url" do
      it "should append the session key and session id to the upload_url and pass it to the js method call" do
        @session_options.should_receive(:session_options).and_return( {} )
        helper.swf_upload_tag( 'upload_url' ) do
          "hi mom"
        end.should match( /upload_url\?_session_id=12345/ )
      end
      it "should append the custom session key" do
        @session_options.should_receive(:session_options).and_return( {:session_key => 'custom_key'} )
        helper.swf_upload_tag( 'upload_url' ) do
          "hi mom"
        end.should match( /upload_url\?custom_key=12345/ )
      end
    end
    describe "protecting against forgery" do 
      before do
        @session_options.stub!(:session_options => {})
        helper.stub!( :form_authenticity_token => 'secret_token' )
      end
      describe "when protecting" do
        before do
          helper.should_receive( :protect_against_forgery? ).and_return(true)
        end
        it "should add the authenticity token to the settings object" do
          out = helper.swf_upload_tag( '/' )
          post_params = parse_json_from_output(out)["post_params"]
          post_params.should == { "authenticity_token" => "secret_token" }
        end
      end
      describe "when not protecting" do
        before do
          helper.should_receive( :protect_against_forgery? ).and_return(false)
        end
        it "should not add the authenticity token to the settings object" do
          out = helper.swf_upload_tag( '/' )
          parse_json_from_output(out)["post_params"].should be_nil
        end
      end
    end
    describe "button_placeholder_id" do
      before do
        @session_options.stub!(:session_options => {})
        helper.stub!( :form_authenticity_token => 'secret_token' )
      end
      it "should add a div to hold the place of the button with an id of browse_files by default" do
        out = helper.swf_upload_tag( '/' )
        out.should have_tag( 'div#browse_files' )
        parse_json_from_output(out)['button_placeholder_id'].should == 'browse_files'
      end
      it "should add a div to hold the place of the button" do
        out = helper.swf_upload_tag( '/', :button_placeholder_id => 'a_button_placeholder' )

        out.should have_tag( 'div#a_button_placeholder' )
        parse_json_from_output(out)['button_placeholder_id'].should == 'a_button_placeholder'
      end
    end

    describe "button test" do
      it "should be the content of the capture" do
        @session_options.stub!(:session_options => {})
        out = helper.swf_upload_tag( '/', :button_placeholder_id => 'a_button_placeholder' ) do 
          "hello?"
        end
        parse_json_from_output(out)['button_text'].should == 'hello?'
      end
    end
  end
  def parse_json_from_output(out)
    ActiveSupport::JSON.decode(out.match( /\(.*\((.*?)\)/ )[1].gsub(/\\/,''))
  end
end
