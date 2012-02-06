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
    ['pug','placeholder','kitten','zombie', 'babe']
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
    babes = [
      "http://2.bp.blogspot.com/_XmYwA_GdPeo/TJKcvCGlA2I/AAAAAAAAJ9M/7Bz5lkgFwLA/s1600/miranda-kerr-swim-0310-4.jpg",
      "http://img.jesper.nu/view/6819/miranda-kerr-0111-05.jpg",
      "http://blog.modelmanagement.com/library/uploads/alexandra-ambrosia-for-victorias-secret-catalouge-20091.jpg",
      "http://cornersmagazine.com/wp-content/uploads/2011/11/miranda-kerr-victoria-secret.jpg",
      "http://www.activedollhouse.com/wp-content/gallery/maxim-cover-march-2009/maxim4.jpg",
      "http://starsmedia.ign.com/stars/image/article/998/998906/babe-of-the-week-062609-20090626035641059-000.jpg",
      "http://headblitz.com/wp-content/uploads/2010/10/Busty-Babe.jpg",
      "http://iphonetoolbox.com/wp-content/uploads/2008/08/hot-babe-07-f.jpg",
      "http://www.runningwithscissors.com/images/postal-babes/belinda-strange/postal-babe-belinda-strange-20.jpg",
      "http://www.jpegwallpapers.com/images/wallpapers/Babe-18-241499.jpeg",
      "http://starsmedia.ign.com/stars/image/article/827/827049/babe-of-the-week-101207-20071012034114041-000.jpg",
      "http://www.ridelust.com/wp-content/uploads/car_girl_tuner_car.jpg",
      "http://1.bp.blogspot.com/_QQ9atl4wcXI/TF6FHvjqxAI/AAAAAAAAApM/GhIgT7N8Hi8/s1600/babe-of-the-week-080108-20080801014859705-000.jpg",
      "http://www.strangecelebrities.com/images/content/125738.jpg",
      "http://1.bp.blogspot.com/-3l7ytzWTqsw/TkIoMJIBIPI/AAAAAAAAAIQ/Cy6owDC0S7U/s1600/sexy_lucy_pinder_black%2B7.jpg",
      "http://girlnight.info/Sexy_Girl_At_Night__9__b.jpg",
      "http://thaiintelligentnews.files.wordpress.com/2010/11/victoria-s-secret-very-sexy-topless-bikini_sexy-victorias-secret-swimsuits.jpg",
      "http://1.bp.blogspot.com/-FGLBXqdvG9k/Th3h7RPBpWI/AAAAAAAAH9w/S3MQjw-03eA/s1600/Sexy+Image+nurse.jpg",
      "http://4.bp.blogspot.com/-VJxfeU0vCI4/Th3h3Fi7mYI/AAAAAAAAH9U/8SLQyr2NQZs/s1600/ayesha+Sexy+Image.jpg",
      "http://fr.flash-screen.com/free-wallpaper/uploads/200603/imgs/1141532161_1024x768_jessica-alba-photo-jessica-alba-sexy-photo.jpg",
      "http://www.pulsarmedia.ro/data/media/19/Nikki%20Visser%201024X768%202822%20Sexy%20Wallpaper.jpg",
      "http://3.bp.blogspot.com/-76wqSGJhDLw/Th3h9Tt9NbI/AAAAAAAAH94/CaLiZPawcno/s1600/Sexy+Image+singles.jpg",
    ]
    #NEED MOOOOOOAR
    
    @file = open(babes[rand babes.length])
    @image = MiniMagick::Image.read(@file.read)
    resize_image
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