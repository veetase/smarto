class BeijingShowJob
  include Sidekiq::Worker
  def perform
    heat_map_names = ["beijing_a", "beijing_as", "beijing_apm", "beijing_av",
                      "beijing_b", "beijing_bs", "beijing_bpm", "beijing_bv",
                      "beijing_c", "beijing_cs", "beijing_cpm", "beijing_cv",
                      "beijing_d", "beijing_ds", "beijing_dpm", "beijing_dv",
                      "shenzhen_a", "shenzhen_as", "shenzhen_apm", "shenzhen_av",
                      "shenzhen_b", "shenzhen_bs", "shenzhen_bpm", "shenzhen_bv",
                      "shenzhen_c", "shenzhen_cs", "shenzhen_cpm", "shenzhen_cv"]
    heat_map_names.each do |h|
      #  clear_map(h)
      if current_map(h)
        update_map(h)
      else
        create_heatmap(h)
      end
    end
  end

  def create_heatmap(name)
    zone_name = get_zone_name(name)

    map = []
    30.times do
      map << zone_init_maps[zone_name.to_sym]
    end
    $redis.set(name, map.to_json)
  end

  def set_position(x, y)
    {x: rand(x), y: rand(y)}
  end

  def current_map(name)
    map = $redis.get(name)
    format_map = JSON.load(map)
    return format_map
  end

  def zone_init_maps
    {
      beijing_a: set_position(80...160, 160...320),
      beijing_b: set_position(100...230, 40...155),
      beijing_c: set_position(320...380, 100...150),
      beijing_d: set_position(250...350, 250...300),
      shenzhen_a: set_position(280...360, 40...80),
      shenzhen_b: set_position(130...190, 230...340),
      shenzhen_c: set_position(250...320, 300...350)
   }
  end

  def update_map(name)
    zone_name = get_zone_name(name)
    map = current_map(name)
    map.shift(2)
    2.times do
      map << zone_init_maps[zone_name.to_sym]
    end
    $redis.set(name, map.to_json)
  end

  def get_zone_name(name)
    final_name  = nil
    if name.include?("beijing_a")
      final_name = "beijing_a"
    elsif name.include?("beijing_b")
      final_name = "beijing_b"
    elsif name.include?("beijing_c")
      final_name = "beijing_c"
    elsif name.include?("beijing_d")
      final_name = "beijing_d"
    elsif name.include?("shenzhen_a")
      final_name = "shenzhen_a"
    elsif name.include?("shenzhen_b")
      final_name = "shenzhen_b"
    elsif name.include?("shenzhen_c")
      final_name = "shenzhen_c"
    end

    final_name
  end

  def clear_map(name)
    $redis.set(name, nil)
  end
end
