# The helper module we include into ActionController::Base
module SwfUploadHelper

  # Form a JS include tag for the SWFUpload JS src and a stylesheet link for inclusion in the <head>
  def include_swf_upload
    javascript_include_tag( %w{ swfupload swfupload/handlers swfupload/fileprogress swfupload/queue swfupload/init } ) << 
      stylesheet_link_tag( "swfupload" )
  end

  # initialize swf upload. arguments:
  # +upload_url+:: the url you want swf upload to post to.
  # +options+::    any setting that can be set on the SwfUpload settings object can be passed in http://demo.swfupload.org/Documentation/#settingsobject.
  # all of the required settings will be set by this plugin.
  # if a block is given it will be passed to the button_text member of the settings object.
  def swf_upload_tag( upload_url, options = {},  &block)
    if progress_target_id = options.delete( :progress_target_id )
      options.merge!( :custom_settings => { :progressTarget => progress_target_id } )
    end

    opts = add_auth_token_if_needed( DEFAULT_OPTIONS.merge( :upload_url => append_session_key(upload_url) ) ).merge(options)

    out = content_tag( :div, '',  :id => opts[:button_placeholder_id] ) << update_page_tag do |page|
      page.call "SWFUpload.init", "(#{opts.to_json})"
    end

    if block_given? 
      options.merge!( :button_text => capture(&block) )
      concat( out, block.binding )
    else
      out
    end
  end
  private

  def append_session_key(url)
    url + "?#{ u request.session_options[:session_key] || '_session_id' }=#{ u( session.session_id ) }"
  end

  def add_auth_token_if_needed( options )
    if protect_against_forgery?
      options.merge( :post_params => { :authenticity_token => u( form_authenticity_token ) } )
    else
      options
    end
  end

  DEFAULT_OPTIONS = { 
    :flash_url              => '/flash/swfupload.swf',
    :button_placeholder_id  => 'browse_files',
    :custom_settings => { 
      :progressTarget => 'progress_target'
    }
  }
end
