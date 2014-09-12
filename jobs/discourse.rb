require 'discourse_api'
require 'dotenv'

Dotenv.load

api_url  = ENV['DISCOURSE_API_URL']
api_key  = ENV['DISCOURSE_API_KEY']
api_user = ENV['DISCOURSE_API_USER']

client = DiscourseApi::Client.new(api_url, api_key, api_user)


SCHEDULER.every '10m', :first_in => 0 do |job|
  latest_topics = client.latest_topics
  new_topics    = client.new_topics

  if latest_topics
    latest_topics = latest_topics.map do |topic|
      { label: topic['title'], value: topic['posts_count'] }
    end
    send_event('discourse_latest_topics', items: latest_topics)
  end

  if new_topics
    new_topics = new_topics.map do |topic|
      { label: topic['title'], value: topic['posts_count'] }
    end
    send_event('discourse_new_topics', items: new_topics)
  end
end