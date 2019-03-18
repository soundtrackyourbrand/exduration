defmodule ExDurationTest do
  use ExUnit.Case
  doctest ExDuration

  test "format zero" do
    assert ExDuration.format(0, :millisecond) == "0s"
  end

  test "format negative duration" do
    assert ExDuration.format(-1, :second) == "-1s"
  end

  test "raises on non-integers" do
    assert_raise RuntimeError, fn ->
      ExDuration.format("", :second)
    end

    assert_raise RuntimeError, fn ->
      ExDuration.format(1.0, :second)
    end

    assert_raise RuntimeError, fn ->
      ExDuration.format([], :second)
    end
  end
end
