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
    config.api_key    = '552656284986424'
    config.api_secret = 'LF9pQZT68RxFqZnnJjDA1L8Q6W8'
  end
  CLOUDINARY_URL='cloudinary://552656284986424:LF9pQZT68RxFqZnnJjDA1L8Q6W8@hfnqsrwbp'
end

get '/' do
  erb :index, :layout => :layout
end

get '/posters' do
  @posters = Poster.all
  erb :posters, :layout => :layout
end

get '/:uri' do
  poster = Poster.where(:uri => params[:uri]).first
  erb :uri, :layout => "layouts/#{poster.layout.file_name}"
end

post '/' do
  content_type :json

  if params[:image]
    upload = Cloudinary::Uploader.upload(File.open(params[:image][:tempfile]))
    logger.info "-----#{upload}"
  end
  #{"public_id"=>"tzvmzdbrbu2oe2s4dbr4",
  # "version"=>1370128250,
  # "signature"=>"bb0e8e7f8a15d234797f1c7c71de4883fcfde167",
  # "width"=>462,
  # "height"=>580,
  # "format"=>"jpg",
  # "resource_type"=>"image",
  # "created_at"=>"2013-06-01T23:10:50Z",
  # "bytes"=>56908,
  # "type"=>"upload",
  # "url"=>"http://res.cloudinary.com/hfnqsrwbp/image/upload/v1370128250/tzvmzdbrbu2oe2s4dbr4.jpg",
  # "secure_url"=>"https://cloudinary-a.akamaihd.net/hfnqsrwbp/image/upload/v1370128250/tzvmzdbrbu2oe2s4dbr4.jpg"
  #}

  @poster = Poster.new(
      :uri          => '',
      :layout_id    => params[:layout_id].to_i,
      :name         => params[:name],
      :color        => params[:color],
      :note         => params[:note],
      :phone        => params[:phone],
      :email        => params[:email],
      :image_id     => upload['public_id'],
      :image_format => upload['format'],
      :image_url    => upload['url'],
      :created_at   => Time.now
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

get '/:id/delete' do
  poster = Poster.get(params[:id].to_i)

  Cloudinary::Api.delete_resources([poster.image_id])

  poster.destroy

  redirect '/posters'
end

post '/subscribe' do
  content_type :json
end
