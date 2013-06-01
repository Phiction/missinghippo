require 'sinatra'
require 'data_mapper' # requires all the gems listed above
require 'json'
require './config/database'

enable :logging
use Rack::Logger

get '/' do
  erb :index, :layout => :layout
end

get '/:uri' do
  poster = Poster.where(:uri => params[:uri]).first
  erb :uri, :layout => "layouts/#{poster.layout.file_name}"
end

post '/' do
  content_type :json

  @poster = Poster.new(
      :uri        => '',
      :layout_id  => params[:layout_id].to_i,
      :name       => params[:name],
      :color      => params[:color],
      :note       => params[:note],
      :phone      => params[:phone],
      :email      => params[:email],
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
