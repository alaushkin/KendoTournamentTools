class UploadController < ApplicationController
  def upload_image
    p params.to_json
    uploaded_io = params[:file][:data]
    @file_name = UUID.new.generate.to_s+'.'+uploaded_io.original_filename.split('.').last
    File.open(Rails.root.join('public', 'uploads', @file_name), 'wb') do |file|
      file.write(uploaded_io.read)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def get_image
    p params[:file_name]
    send_data open("#{Rails.root}/public/uploads/"+params[:file_name], "rb").read
  end
end