config_file = Rails.root + "config" + "mongo.yml"
config_text = File.read(config_file)
config_hash = YAML.load(config_text)
config_env = config_hash[Rails.env]
config = config_env.symbolize_keys

Rails.application.config.mongodb_config = config

c2 = config.dup

host = c2.delete(:host)
port = c2.delete(:port)

MONGO_CLIENT = Mongo::Client.new(["#{host}:#{port}"], c2)
