class BeijingShowJob
  include Sidekiq::Worker
  def perform
    hot_names = ["hot_temp", "hot_hum", "hot_pm", "hot_v"]
    cold_names = ["cold_temp", "cold_hum", "cold_pm", "cold_v"]

    hot_names.each do |h|
      if current_dots(h)
        update_dots(h, "hot")
      else
        create_dots(h, "hot")
      end
    end

    cold_names.each do |c|
      if current_dots(c)
        update_dots(c, "cold")
      else
        create_dots(c, "cold")
      end
    end
  end

  def full_map
    {x: 100...280, y: 210...217}
  end

  def cold_map
    {x: 380...480, y: 50...150}
  end

  def cold_visual_map
    {x: 380...480, y: 50...150}
  end

  def create_dots(name, type)
    dots = []
    if type == "hot"
      50.times do
        dots << set_hot_dots
      end
    else
      20.times do
        dots << set_cold_dots
      end
    end
    $redis.set(name, dots.to_json)
  end

  def set_hot_dots
    begin
      x = rand(full_map[:x])
      y = rand(full_map[:y])
    end while(cold_map[:x].include?(x) && cold_map[:y].include?(y))
    {x: x, y: y}
  end

  def set_cold_dots
    {x: rand(cold_visual_map[:x]), y: rand(cold_visual_map[:y])}
  end

  def current_dots(name)
    dots = $redis.get(name)
    format_dots = JSON.load(dots)
    return format_dots
  end

  def update_dots(name, type)
    dots = current_dots(name)
    dots.shift(2)
    if type == "hot"
      2.times do
        dots << set_hot_dots
      end
    else
      2.times do
        dots << set_cold_dots
      end
    end
    $redis.set(name, dots.to_json)
  end

  def clear_map(name)
    $redis.set(name, nil)
  end
end
