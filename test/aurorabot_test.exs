defmodule AurorabotTest do
  use ExUnit.Case
  doctest Aurorabot

  test "greets the world" do
    assert Aurorabot.hello() == :world
  end
end
