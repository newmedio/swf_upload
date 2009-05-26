module SwfUpload
  # When this module is included, extend it with the available class methods
  def self.included(base)
    base.extend(ClassMethods)
  end
  module ClassMethods
    def responds_to_swf_upload( options = {} )
      self.class_eval do
        #session( { :cookie_only => false }.merge(options) )
      end
    end
  end
end
require 'rack/utils'
 
class FlashSessionCookieMiddleware
  def initialize(app)
    @app = app
  end
 
  def call(env)
    if env['HTTP_USER_AGENT'] =~ /^(Adobe|Shockwave) Flash/
      session_key = ActionController::Base.session_options[:key]
      params = ::Rack::Utils.parse_query(env['QUERY_STRING'])
      env['HTTP_COOKIE'] = [ session_key, params[session_key] ].join('=').freeze unless params[session_key].nil?
    end
    @app.call(env)
  end
end
 
ActionController::Dispatcher.middleware.insert_before ActionController::Session::CookieStore, FlashSessionCookieMiddleware

