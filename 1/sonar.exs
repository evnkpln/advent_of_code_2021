defmodule Sonar do
  def increases([]), do: 0
  def increases([depth | tail]), do: increases(tail, depth)
  def increases(file_path) when is_bitstring(file_path) do
    file_path
      |> parse_readings
      |> increases
  end

  def increases([], _last_depth), do: 0
  def increases([depth | tail], last_depth) when depth > last_depth do
    1 + increases(tail, depth)
  end
  def increases([depth | tail], _last_depth), do: increases(tail, depth)

  def parse_readings(file_path) do
    {:ok, content} = File.read(file_path)
    content
      |> String.trim
      |> String.split
      |> Enum.map(&(String.to_integer(&1)))
  end

  def stable_increases([]), do: 0
  def stable_increases([depth | tail]), do: stable_increases(tail, [depth])
  def stable_increases(file_path) when is_bitstring(file_path) do
    file_path
      |> parse_readings
      |> stable_increases
  end

  def stable_increases([], _window), do: 0
  def stable_increases([depth | tail], window) do
    case length window do
      1 -> stable_increases(tail, [depth | window])
      2 -> stable_increases(tail, [depth | window])
      3 ->
        new_window = window
          |> List.delete_at(2)
          |> List.insert_at(0, depth)
        compare_windows(window,new_window) + stable_increases(tail, new_window)
    end
  end

  defp compare_windows(last_window, new_window) do
    if Enum.sum(new_window) > Enum.sum(last_window) do
      1
    else
      0
    end
  end
end

# IO.puts(Sonar.increases("sample.txt") == 3)
# IO.puts(Sonar.increases([1,0,4,6,44,4,5]) == 4)
# IO.puts(Sonar.stable_increases([1,2,3,2,3,4,1]))
# IO.puts(Sonar.stable_increases([1,2,3,2,3,4,1]) == 3)
IO.puts(Sonar.increases("input.txt"))
IO.puts(Sonar.stable_increases("input.txt"))
