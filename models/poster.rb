class Poster
  include DataMapper::Resource

  property :id,           Serial
  property :uri,          String
  property :layout_id,    Integer
  property :name,         String
  property :color,        String
  property :note,         Text
  property :image_id,     String
  property :image_format, String
  property :image_url,    Text

  property :phone,        String
  property :email,        String

  property :created_at,   DateTime

  has n, :layouts

  validates_presence_of :layout_id
end