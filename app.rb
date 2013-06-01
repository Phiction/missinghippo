require 'sinatra'
require 'data_mapper' # requires all the gems listed above
require 'json'
require 'cloudinary'
require './config/database'

enable :logging
use Rack::Logger

configure :development do
  Cloudinary.config do |config|
    config.cloud_name = 'hfnqsrwbp'
    config.api_key = '552656284986424'
    config.api_secret = 'LF9pQZT68RxFqZnnJjDA1L8Q6W8'
  end
  CLOUDINARY_URL='cloudinary://552656284986424:LF9pQZT68RxFqZnnJjDA1L8Q6W8@hfnqsrwbp'
end

get '/' do
  erb :index, :layout => :layout
end

get '/:uri' do
  poster = Poster.where(:uri => params[:uri]).first
  erb :uri, :layout => "layouts/#{poster.layout.file_name}"
end

post '/' do
  content_type :json
  logger.info "-----#{params}-----"
  if params[:image]
    upload = Cloudinary::Uploader.upload(File.open(params[:image][:tempfile]))
  end
  #{
  #    :url        => 'http://res.cloudinary.com/demo/image/upload/sample.jpg',
  #    :secure_url => 'https://cloudinary-a.akamaihd.net/demo/image/upload/sample.jpg',
  #    :public_id  => 'sample',
  #    :version    => '1312461204',
  #    :width      => 864,
  #    :height     => 564,
  #    :bytes      => 120253
  #}
  logger.info "-----#{upload['url']}-----"
  @poster = Poster.new(
      :uri        => '',
      :layout_id  => params[:layout_id].to_i,
      :name       => params[:name],
      :color      => params[:color],
      :note       => params[:note],
      :phone      => params[:phone],
      :email      => params[:email],
      :image_url  => upload['url'],
      :created_at => Time.now
  )

  if @poster.save
    if @poster.update(:uri => @poster.id.to_s(36))
      { :url => "http://missinghippo.com/#{@poster.uri}.pdf" }.to_json
    else
      { :errors => 'Not a valid URL format' }.to_json
    end
  else
    #@poster.errors.each do |e|
    #  #Pusher['test_channel'].trigger('errors', { :message => e })
    #end
    { :errors => @poster.errors.full_messages }.to_json
  end
end

post '/subscribe' do
  content_type :json
end
