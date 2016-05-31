# Parcel

Elixir based pagination plug for Maru

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add parcel to your list of dependencies in `mix.exs`:

        def deps do
          [{:parcel, "~> 0.0.1"}]
        end

  2. Ensure parcel is started before your application:

        def application do
          [applications: [:parcel]]
        end
