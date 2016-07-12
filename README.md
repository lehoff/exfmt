# Exfmt

Auto-formatter for Elixir based on the prettypr library from the OTP distribution.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `exfmt` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:exfmt, "~> 0.1.0"}]
    end
    ```

  2. Ensure `exfmt` is started before your application:

    ```elixir
    def application do
      [applications: [:exfmt]]
    end
    ```
