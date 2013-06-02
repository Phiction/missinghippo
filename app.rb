require 'sinatra'
require 'data_mapper' # requires all the gems listed above
require 'json'
require 'cloudinary'
require './config/database'
require 'pdfkit'

use PDFKit::Middleware

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

PDFKit.configure do |config|
  config.default_options = {
      :page_size     => 'Letter',
      :margin_top    => '0.4in',
      :margin_right  => '0.5in',
      :margin_bottom => '0.5in',
      :margin_left   => '0.5in'
  }
end

get '/' do
  erb :index, :layout => :parasponsive
end

get '/posters' do
  @posters = Poster.all
  erb :posters, :layout => :layout
end

get '/:uri.:format' do
  @poster = Poster.first(:uri => params[:uri])

  case params[:format]
    when 'html'
      erb :uri, :layout => "layouts/#{@poster.layout.file_name}".to_sym
    when 'pdf'
      url = "/#{@poster.uri}.html"
      kit = PDFKit.new(url, :page_size => 'Letter')
      pdf = kit.to_pdf
    else
      erb :uri, :layout => "layouts/#{@poster.layout.file_name}".to_sym
  end
end

get '/:uri' do
  @poster = Poster.first(:uri => params[:uri])
  erb :uri, :layout => "layouts/#{@poster.layout.file_name}".to_sym
end

get '/:id/delete' do
  poster = Poster.get(params[:id].to_i)

  Cloudinary::Api.delete_resources([poster.image_id])

  poster.destroy

  redirect '/posters'
end

post '/' do
  content_type :json

  if params[:image]
    upload = Cloudinary::Uploader.upload(File.open(params[:image][:tempfile]))
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
      :uri           => '',
      :zip_code      => params[:zip_code].to_i,
      :contact_name  => params[:contact_name],
      :contact_phone => params[:contact_phone],
      :contact_email => params[:contact_email],

      :layout_id     => params[:layout_id].to_i,
      :name          => params[:name],
      :breed         => params[:breed],
      :gender        => params[:gender].to_i,
      :age           => params[:age],
      :color         => params[:color],
      :note          => params[:note],
      :location      => params[:location],
      :reward        => params[:reward],

      :created_at    => Time.now
  )

  if params[:image]
    @poster.image_id     = upload['public_id']
    @poster.image_format = upload['format']
    @poster.image_url    = upload['url']
  end

  if @poster.save
    if @poster.update(:uri => @poster.id.to_s(36))
      @poster.to_json
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
