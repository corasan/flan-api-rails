
FirebaseIdToken.configure do |config|
  config.redis = Redis.new
  config.project_ids = ['flan-45128']
end