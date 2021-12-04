defmodule Helm do
  defmodule Coordinates do
    defstruct depth: 0, horizontal: 0
  end
  defmodule Heading do
    defstruct depth: 0, horizontal: 0, aim: 0
  end

  def initialize_position do
    %Coordinates{}
  end

  def initialize_heading do
    %Heading{}
  end

  def move({direction, distance}, coordinates = %Coordinates{}) do
    case direction do
      :up -> %{coordinates | depth: coordinates.depth - distance}
      :down -> %{coordinates | depth: coordinates.depth + distance}
      :forward -> %{coordinates | horizontal: coordinates.horizontal + distance}
    end
  end
  def move({direction, distance}, heading = %Heading{}) do
    case direction do
      :up -> %{heading | aim: heading.aim - distance}
      :down -> %{heading | aim: heading.aim + distance}
      :forward ->
        %{
          heading
          |
          horizontal: heading.horizontal + distance,
          depth: heading.depth + (distance * heading.aim)
        }
    end
  end

  def parse_instructions(file_path) do
    {:ok, content} = File.read(file_path)
    content
      |> String.trim
      |> String.split("\n")
      |> Enum.map(&(String.split(&1)))
      |> Enum.map(&(list_to_move_tuple(&1)))
  end

  def apply_instructions(coordinates, instructions) do
    Enum.reduce(instructions, coordinates, &move/2)
  end

  def area_covered(coordinates), do: coordinates.depth * coordinates.horizontal

  defp list_to_move_tuple([direction, distance]) do
    {String.to_atom(direction), String.to_integer(distance)}
  end
end

#Part 1
instructions = Helm.parse_instructions("input.txt")
Helm.initialize_position()
  |> Helm.apply_instructions(instructions)
  |> Helm.area_covered()
  |> IO.puts()
#Part 2
Helm.initialize_heading()
  |> Helm.apply_instructions(instructions)
  |> Helm.area_covered()
  |> IO.puts()
