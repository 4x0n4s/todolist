defmodule TodolistTest do
  use ExUnit.Case
  doctest Todolist

  test "greets the world" do
    assert Todolist.hello() == :world
  end
end
