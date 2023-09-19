# Configuração

No seu arquivo `config.exs` é necessário declarar quais são os circuitos que serão utilizados pela sua aplicação.
Supondo que exista um módulo de circuito:

```exs
defmodule Application.ExternalApiCircuit do
  use Virgil.Circuit
end
```

será necessário adicionar o seguinte às suas configurações:

```exs
config :virgil, circuits: [Application.ExternalApiCircuit]
```

Desta forma o manager saberá que deve inicializar as tabelas necessárias para este circuito em específico.

# Utilização

Os circuitos podem ser utilizados da seguinte forma.

```exs
defmodule Application.ExternalApiCircuit do
  use Virgil.Circuit,
    error_threshold: 10
end
```
