class Geozone < ApplicationRecord
  include Graphqlable
  include FileAttachable

  attr_accessor :coordinates

  has_many :proposals
  has_many :debates
  has_many :users
  has_many :districts, class_name: "Geozone", foreign_key: "subprefecture_id"
  belongs_to :subprefecture, class_name: "Geozone", optional: true

  validates :name, presence: true

  before_update :update_users

  scope :public_for_api, -> { all }

  def self.names
    Geozone.pluck(:name)
  end

  def self.sub_search lat, long
    Geozone.all.where(active: true, district: false).each do |sub|
      sub.load_coordinates

      if sub.has?(lat, long)
        subprefecture = sub

        subprefecture.districts.each do |district|
          district.load_coordinates
          if district.has? lat, long
            return district
          end
        end
      end
    end
    return nil
  end

  def self.compare results
    districts = []
    results.each do |result|
      districts.push(sub_search(result['lat'], result['lon']))
    end
    districts.uniq.compact
  end

  def self.count_users
    one_address = 0
    many_addresses = 0
    no_address = 0

    users = User.where.not(home_address: nil).where(city: 'São Paulo')
    users.each do |u|
      query = u.address_number + ' ' + u.home_address
      puts u.id
      puts query
      r = OpenStreetMapService.search(query)

      if r.count == 1
        lat = r.first['lat']
        long = r.first['lon']
        u.geozone = sub_search(lat, long)
        u.save
        one_address += 1 
      elsif r.count >= 1
        districts = compare r
        if districts.count > 1
          many_addresses += 1
        elsif districts.count == 1
          lat = r.first['lat']
          long = r.first['lon']
          u.geozone = sub_search(lat, long)
          u.save
          one_address += 1
        end
      else
        no_address += 1
      end

      puts one_address
      puts many_addresses
      puts no_address
    end
  end

  def safe_to_destroy?
    Geozone.reflect_on_all_associations(:has_many).all? do |association|
      association.klass.where(geozone: self).empty?
    end
  end

  def load_coordinates
    self.coordinates = BorderPatrol.parse_kml(File.open document.path)
  end

  def has? lat,long
    self.coordinates.contains_point?(BorderPatrol::Point.new(long.to_f, lat.to_f))
  end

  def archive
    if !district?
      districts.each { |d| d.update active: false }
    end
    update active: false
  end

  private

  def update_users
    if !active || document.attachment_file_size_changed?
      if district?
        User.where(geozone_id: id).update(geozone_id: nil)
      else
        districts.each { |district| district.users.update_all(geozone_id: nil) }
      end
    end
  end
end
