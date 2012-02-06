class ImageController < ApplicationController
  require 'open-uri'
  require 'mini_magick'
  before_filter :get_image

  @image
  @file

  def generate
    send_data @image.to_blob, :type => file_extension_of(@file.content_type), :filename => "#{params[:width]}x#{params[:height]}.#{file_extension_of(@file.content_type)}", :disposition => 'inline'
  end

  private

  private

  def getters
    ['pug','placeholder','kitten','zombie']
  end

  def get_image
    if getters.include? params[:type]
      self.method("get_#{params[:type]}").call
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def resize_image
    width = params['width'].to_f
    height = params['height'].to_f

    @image.geometry("#{width}x#{height}^")

    if @image[:height] > height
      remove = ((@image[:height] - height) / 2).floor
      @image.shave("0x#{remove}")
    elsif @image[:width] > width
      remove = ((@image[:width] - width) / 2).floor
      @image.shave("#{remove}x0")
    end

    #Finally, make super sure the dimensions fit perfectly
    @image.extent("#{width}x#{height}")
  end

  def get_pug
    @file = open(JSON.parse(open("http://pugme.herokuapp.com/random").read)['pug'])
    @image = MiniMagick::Image.read(@file.read)
    resize_image
  end

  def get_placeholder
    @file = open("http://placehold.it/#{params[:width]}x#{params[:height]}")
    @image = MiniMagick::Image.read(@file.read)
  end

  def get_kitten
    @file = open("http://placekitten.com/#{params[:width]}/#{params[:height]}")
    @image = MiniMagick::Image.read(@file.read)
  end

  def get_babe
    #THIS HAS TO HAPPEN
    raise ActiveRecord::RecordNotFound
  end

  def get_zombie
    google_results = JSON.parse(open("http://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=8&q=zombie").read)
    @file = open(google_results['responseData']['results'][rand(8).floor]['unescapedUrl'])
    @image = MiniMagick::Image.read(@file.read)
    resize_image
  end

  def file_extension_of(mime_string)
    return $1 if mime_string =~ /(\w+)$/
  end
end