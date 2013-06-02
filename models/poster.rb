class Poster
  include DataMapper::Resource

  property :id,            Serial
  property :uri,           String # TODO => , :default => this.id.to_s(36)
  property :zip_code,      Integer, :required => true

  property :layout_id,     Integer, :default  => 1
  property :name,          String,  :required => true
  property :breed,         String
  property :gender,        Integer
  property :age,           String
  property :color,         String
  property :location,      Text
  property :note,          Text
  property :reward,        Boolean, :default => false

  property :image_id,      String
  property :image_format,  String
  property :image_url,     Text

  property :contact_name,  String
  property :contact_phone, String
  property :contact_email, String

  property :created_at,    DateTime

  #belongs_to :layout

  #:after send_notifications
  #
  #def send_notifications
  #  georangefinder(this.zip_code).each do |z|
  #    users = User.where(:zip_code => z)
  #    users.each do |user|
  #      mandrill.send(:to => user.email, :subject => "Missing Pet in Your Area", :message => missing_notification_layout)
  #    end
  #  end
  #end
end