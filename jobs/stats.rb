SCHEDULER.every '5m', :first_in => 0 do |job|
  discourse_stats = {}
  data = open("https://talk.birmingham.io/about.json").read
  stats = JSON.parse(data)["about"]["stats"]
  stats.find_all { |key,_| key.include?("count") }.each do |key,count|
    discourse_stats[key] = {label: pretty_key(key), value: count}
  end
  send_event('stats', {items: discourse_stats.values})
end

def pretty_key(key)
  key.sub("_count","").capitalize + "s"
end
