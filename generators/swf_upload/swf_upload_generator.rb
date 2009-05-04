class SwfUploadGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      @full_path = "#{ File.dirname(__FILE__) }/templates/"
      Dir["#{@full_path}**/*"].each do |file| 
        if File.directory?(file)
          m.directory(relative_path(file))
        else
          m.file(relative_path(file),relative_path(file))
        end
      end
    end
  end

  private
  def relative_path(file) 
    file.sub(@full_path, '' )
  end
end

