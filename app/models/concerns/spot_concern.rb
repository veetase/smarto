module SpotConcern
  extend ActiveSupport::Concern
  included do
    has_many :comments, as: :commentable, after_add: :add_count
    set_rgeo_factory_for_column(:location, RGeo::Geographic.spherical_factory(:srid => 4326))
    scope :near, lambda { |longitude, latitude, distance|
      where("ST_Distance(location,"+"'POINT(#{longitude} #{latitude})') < #{distance}")
    }
  end

  def add_view_count
    cache_name = view_count_cache
    count = $redis.get(cache_name).to_i
    if count > 10
      self.view_count += count
      self.save
      $redis.set(cache_name, 1) #added one
    else
      $redis.set(cache_name, count + 1)
    end
  end

  def as_json(options={})
    result = super
    result["view_count"] = result["view_count"].to_i + $redis.get(view_count_cache).to_i
    result
  end

  def add_count(coment)
    self.comment_count = self.comment_count + 1

    #merge cached view count when update spot
    cache_name = view_count_cache
    cached_view_count = $redis.get(cache_name).to_i
    self.view_count += cached_view_count

    self.save
    $redis.set(cache_name, 0)
  end

  def view_count_cache
    "#{self.model_name.name.underscore}_#{self.id}"
  end
end
