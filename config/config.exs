import Config

config :tesla, adapter: Tesla.Adapter.Hackney

config :ex_falcon,
  api_key: "XXX",
  secret_key: "XXX",
  passphrase: "XXX",
  base_url: "https://api.falconx.io/v1"

import_config "#{config_env()}.exs"
