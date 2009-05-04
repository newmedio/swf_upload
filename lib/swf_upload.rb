module SwfUpload
  # When this module is included, extend it with the available class methods
  def self.included(base)
    base.extend(ClassMethods)
  end
  module ClassMethods
    def responds_to_swf_upload( options = {} )
      self.class_eval do
        session( { :cookie_only => false }.merge(options) )
      end
    end
  end
end
