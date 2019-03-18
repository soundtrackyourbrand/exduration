defmodule ExDuration do
  @moduledoc """
  Formatting durations into human readable hours, mintes, seconds and sub second strings, like _12h3m_, _45μs_, _67ms_ and _8.9s_.
  """

  @hour trunc(60 * 60 * 1.0e6)
  @minute trunc(60 * 1.0e6)
  @second trunc(1.0e6)
  @millisecond trunc(1.0e3)

  @doc """
  Format `duration`

  ## Examples

      iex> ExDuration.format(100, :microsecond)
      "100μs"
      iex> ExDuration.format(50, :millisecond)
      "50ms"
      iex> ExDuration.format(25, :second)
      "25s"
      iex> ExDuration.format(12, :minute)
      "12m"
      iex> ExDuration.format(6, :hour)
      "6h"
      iex> ExDuration.format(22345050100, :microsecond)
      "6h12m25.0501s"
  """
  @spec format(duration :: integer, :microsecond | :millisecond | :second | :minute | :hour) ::
          String.t()
  def format(duration, _) when not is_integer(duration),
    do: raise("only integer durations are supported")

  def format(duration, _) when duration == 0, do: "0s"

  def format(duration, unit) do
    case unit do
      :microsecond -> format_microsecond(duration)
      :millisecond -> format_microsecond(duration * @millisecond)
      :second -> format_microsecond(duration * @second)
      :minute -> format_microsecond(duration * @minute)
      :hour -> format_microsecond(duration * @hour)
      _ -> raise "unsupported unit #{unit}"
    end
  end

  @doc """
  Format the duration since `start`.

  ## Examples

      iex> start = :os.system_time(:second)
      ...> ExDuration.since(start, :second)
      "0s"

  """
  @spec since(start :: integer, :microsecond | :millisecond | :second) :: String.t()
  def since(start, unit \\ :microsecond) do
    format(:os.system_time(unit) - start, unit)
  end

  @doc """
  Format the duration between `datetime1` and `datetime2`.

  ## Examples

      iex> dt1 = %DateTime{year: 2000, month: 1, day: 1, zone_abbr: "CET",
      ...>                 hour: 10, minute: 10, second: 10, microsecond: {100100, 6},
      ...>                 utc_offset: 3600, std_offset: 0, time_zone: "Europe/Stockholm"}
      iex> dt2 = %DateTime{year: 2000, month: 1, day: 1, zone_abbr: "CET",
      ...>                 hour: 0, minute: 0, second: 0, microsecond: {0, 0},
      ...>                 utc_offset: 3600, std_offset: 0, time_zone: "Europe/Stockholm"}
      iex> ExDuration.between(dt1, dt2)
      "10h10m10.1001s"

  """
  @spec between(Calendar.datetime(), Calendar.datetime()) ::
          String.t()
  def between(datetime1, datetime2) do
    diff = DateTime.diff(datetime1, datetime2, :microsecond)
    format(diff, :microsecond)
  end

  @spec format_microsecond(duration :: integer) :: String.t()
  defp format_microsecond(duration) when duration > 0,
    do: format_microsecond("", duration)

  defp format_microsecond(duration) when duration < 0,
    do: format_microsecond("-", abs(duration))

  @spec format_microsecond(prefix :: String.t(), duration :: integer) :: String.t()
  defp format_microsecond(prefix, duration) when duration > 0 do
    units = [{@hour, "h"}, {@minute, "m"}]
    initial = {[prefix], duration}

    {hm, micros} =
      Enum.reduce(units, initial, fn {n, suffix}, {acc, rem} ->
        case div(rem, n) do
          i when i > 0 -> {acc ++ [i, suffix], rem(rem, n)}
          _ -> {acc, rem}
        end
      end)

    Enum.join(hm ++ [format_second(micros, micros == duration)])
  end

  @spec format_second(duration :: integer, allow_subsecond :: bool) :: String.t()
  defp format_second(micros, allow_subsecond) do
    seconds = trunc(micros / @second)

    case {seconds, micros - seconds * @second} do
      {s, rem} when allow_subsecond and s == 0 and rem < @millisecond ->
        format_μs(rem)

      {s, rem} when allow_subsecond and s == 0 ->
        format_ms(rem)

      {s, rem} when s > 0 ->
        "#{s}#{format_subsecond(rem)}s"

      _ ->
        ""
    end
  end

  @spec format_μs(micros :: integer) :: String.t()
  defp format_μs(micros), do: "#{trunc(micros)}μs"

  @spec format_ms(micros :: integer) :: String.t()
  defp format_ms(micros) do
    ms = trunc(micros / 1000)

    us =
      case trunc(micros - ms * 1000) do
        0 -> ""
        us -> "." <> String.trim_trailing("#{us}", "0")
      end

    "#{ms}#{us}ms"
  end

  @spec format_subsecond(micros :: integer) :: String.t()
  defp format_subsecond(micros) when micros == 0, do: ""

  defp format_subsecond(micros) do
    subsecond =
      "#{trunc(micros)}"
      |> String.pad_leading(6, "0")
      |> String.trim_trailing("0")

    "." <> subsecond
  end
end
