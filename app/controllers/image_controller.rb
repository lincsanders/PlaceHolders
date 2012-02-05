class ImageController < ApplicationController
  require 'open-uri'
  before_filter :get_file

  @image
  @file

  def generate
    send_data @image, :type => file_extension_of(@file.content_type), :filename => "#{params[:width]}x#{params[:height]}.#{file_extension_of(@file.content_type)}", :disposition => 'inline'
  end

  private

  def get_file
    @file = open(get_image)
    @image = @file.read
  end

  private

  def get_image
    if params[:type]=='pug'
      get_pug
    elsif params[:type]=='babe'
      get_babe
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def get_pug
    JSON.parse(open("http://pugme.herokuapp.com/random").read)['pug']
  end

  def get_babe
    raise ActiveRecord::RecordNotFound
  end

  def file_extension_of(mime_string)
    return $1 if mime_string =~ /(\w+)$/
  end
end