import Config

# config :tesla, MyClient, adapter: Tesla.Adapter.Tape
config :tesla, adapter: Tesla.Adapter.Hackney

config :ex_falcon,
  api_key: "XXX",
  secret_key: "XXX"
  passphrase: "XXX",
  base_url: "https://qa.falconxdev.com/"
