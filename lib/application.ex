defmodule CircuitBreaker.Application do
  use Application

  alias CircuitBreaker.ManagerServer

  def start(_type, _args) do
    children = [
      ManagerServer
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
