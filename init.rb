require 'swf_upload'
require 'swf_upload_helper'

ActionController::Base.send(:include, SwfUpload)
ActionController::Base.send(:helper, SwfUploadHelper)
