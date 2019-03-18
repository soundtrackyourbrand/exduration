# ExDuration

Formatting durations like _12h3m_, _45μs_, _67ms_ and _8.9s_.

## Usage

```elixir
# Format a duration
@interval_ms 6000
Logger.info("doing work every #{ExDuration.format(@interval_ms, :millisecond)}")

# Format the duration since a timestamp
start = :os.system_time(:millisecond)
_ = work()
Logger.info("work took #{ExDuration.since(start, :millisecond)}")

# Format the duration between two DateTime's
Logger.info("A and B are #{ExDuration.between(dt1, dt2)} apart")
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `exduration` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:exduration, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/exduration](https://hexdocs.pm/exduration).

