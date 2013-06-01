class Poster
  include DataMapper::Resource

  property :id,         Serial
  property :uri,        String
  property :layout_id,  Integer
  property :name,       String
  property :color,      String
  property :note,       Text
  property :phone,      String
  property :email,      String
  property :created_at, DateTime

  has n, :layouts
end