class User
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String, :nullable => false, :unique => true, :unique_index => true
  property :email,      String,                     :unique => true, :unique_index => true
  property :openid_url, String,                     :unique => true, :unique_index => true

  validates_format :email, :as => :email_address

  def password_required?
    openid_url.nil?
  end
end
