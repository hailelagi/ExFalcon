import Config

config :tesla, adapter: Tesla.Adapter.Hackney

config :ex_falcon,
  api_key: "value1",
  passphrase: "value2"

import_config "#{config_env()}.exs"
