require 'json'
class Document < ApplicationRecord

    attr_accessor :uploaded_file
    
    belongs_to :user

    before_validation :set_params
    after_save :upload
    after_destroy :delete_document
  
    validates :description, :presence => true
    validates :name, :presence => true
    validates :path, :presence => true, :uniqueness =>true
    validates :user_id, :presence => true
  

    def set_params
      return false if self.path.nil?
    
      path = JSON.parse(self.path, symbolize_names: true)
      
      hash = DateTime.now.strftime("%Q")
      hashed_name = "#{hash}_#{path[:original_filename]}"
      uploaded_file = ActionDispatch::Http::UploadedFile.new(
        filename: File.basename(path[:original_filename]),
        type: Mime::Type.lookup_by_extension(File.extname(hashed_name)[1..-1]),
        tempfile: File.new(path[:path])
      )
    
      self.name = uploaded_file.original_filename

      self.uploaded_file = uploaded_file
      
      dir = "./uploaded_documents"
      Dir.mkdir(dir) unless File.exists?(dir)
      self.path = File.join(dir, hashed_name)
    end
    
  
    def upload 
      return false if self.uploaded_file.nil?    
      @document = File.open(self.uploaded_file, "rb")
      File.open(self.path, "wb") do |f| 
        f.write(@document.read); 
        f.rewind; 
      end
      @document.close
    end
    
  
    def delete_document
      File.delete(self.path) if File.exists?(self.path)
    end
end
