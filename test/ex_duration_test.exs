defmodule ExDurationTest do
  use ExUnit.Case
  doctest ExDuration

  describe "format" do
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

  describe "parse" do
    test "microsecond" do
      assert ExDuration.parse("1000000μs", :second) == {:ok, 1}
      assert ExDuration.parse("1500000μs", :second) == {:ok, 1}
      assert ExDuration.parse("1500000μs", :millisecond) == {:ok, 1500}
    end

    test "milliseconds" do
      assert ExDuration.parse("1000ms", :second) == {:ok, 1}
      assert ExDuration.parse("1500ms", :second) == {:ok, 1}
      assert ExDuration.parse("1500ms", :microsecond) == {:ok, 1_500_000}
    end

    test "second" do
      assert ExDuration.parse("1s", :millisecond) == {:ok, 1000}
      assert ExDuration.parse("1.5s", :millisecond) == {:ok, 1500}
      assert ExDuration.parse("1.5s", :second) == {:ok, 1}

      assert ExDuration.parse("3600s", :hour) == {:ok, 1}
    end

    test "minute" do
      assert ExDuration.parse("1m", :second) == {:ok, 60}
      assert ExDuration.parse("1440m", :hour) == {:ok, 24}
    end

    test "hour" do
      assert ExDuration.parse("1h", :second) == {:ok, 3600}
      assert ExDuration.parse("24h", :minute) == {:ok, 1440}
    end

    test "composite" do
      assert ExDuration.parse("1h1m1s", :second) == {:ok, 3661}
      assert ExDuration.parse("1h1m1.1s", :second) == {:ok, 3661}
      assert ExDuration.parse("1h1m1.1s", :millisecond) == {:ok, 3_661_100}
      assert ExDuration.parse("1h1m1.1001s", :microsecond) == {:ok, 3_661_100100}

      assert ExDuration.parse("1m1s", :second) == {:ok, 61}
      assert ExDuration.parse("1h1s", :second) == {:ok, 3601}
      assert ExDuration.parse("1h1.1s", :millisecond) == {:ok, 3_601_100}
    end
  end
end
