import Config

config :logger, :console,
  level: :debug,
  format: "[$level] $message $metadata\n"

config :virgil,
  circuits: [
    Example,
    Test,
    FakeCircuit,
    TestCircuit.Circuit
  ]
