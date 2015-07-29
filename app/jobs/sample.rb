Dashing.scheduler.every '20s' do
  now = Time.now
  users_count = User.count
  users_today = User.where("created_at >= ?", now.beginning_of_day).count
  spots_today = Spot.where("created_at >= ?", now.beginning_of_day).count
  spots_all = Spot.count

  users_yesterday = User.where("created_at >= ? and created_at < ?", now.yesterday.beginning_of_day, (now - 1.day)).count
  spots_yesterday = Spot.where("created_at >= ? and created_at < ?", now.yesterday.beginning_of_day, (now - 1.day)).count
  users_weekly = User.where("created_at >= ?", 30.days.ago.beginning_of_day).order('date(created_at)').group("date(created_at)").count
  points= users_weekly.collect{|k, v| {"x": k.beginning_of_day.to_i, "y": v}.as_json}
  Dashing.send_event('today_users', { current: users_today, last: users_yesterday })
  Dashing.send_event('today_spots', { current: spots_today, last: spots_yesterday })
  Dashing.send_event('total_users', { value: users_count })
  Dashing.send_event('spots',   { value: spots_all })
  Dashing.send_event('users', points: points)
end
