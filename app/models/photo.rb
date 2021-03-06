class Photo < ActiveRecord::Base
  validates :flickr_id, :presence => true, :uniqueness => true
  scope :recent, order("flickr_id DESC").limit(12)
    
  def self.fetch
    FlickRaw.api_key = SERVICES['flickr']['api_key']
    FlickRaw.shared_secret = SERVICES['flickr']['shared_secret']
    flickr.access_token = SERVICES['flickr']['auth_token']
    flickr.access_secret = SERVICES['flickr']['auth_secret']

    if photos = flickr.people.getPhotos(:user_id => SERVICES['flickr']['user_id'])
      photos.each do |photo|
        new_photo = self.new
        new_photo.flickr_id = photo.id
        new_photo.title = photo.title
        new_photo.flickr_url = FlickRaw.url_photopage photo
        new_photo.url_small = FlickRaw.url_m photo
        new_photo.url_square = FlickRaw.url_s photo
        new_photo.url = FlickRaw.url_z photo
        
        new_photo.save
      end
    end    
  end
end
