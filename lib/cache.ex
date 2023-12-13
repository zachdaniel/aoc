defmodule Aoc.Cache do
  use Nebulex.Cache,
    otp_app: :aoc,
    adapter: Nebulex.Adapters.Local
end
