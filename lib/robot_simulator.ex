defmodule RobotSimulator do
  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0, 0}) do

    valid = {is_valid_direction(direction), is_valid_position(position)}

    case valid do
      {false, _} -> {:error, "invalid direction"}
      {true, false} -> {:error, "invalid position"}
      _ -> %RobotSimulator.Robot{cur_direction: direction, cur_position: position}
    end
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    instructions
    |> String.graphemes
    |> Enum.reduce_while(robot, fn e, acc -> do_robot_step(e, acc) end)
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(robot) when is_struct(robot, RobotSimulator.Robot) do
    robot.cur_direction
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(robot) when is_struct(robot, RobotSimulator.Robot) do
    robot.cur_position
  end

  defp is_valid_direction(direction) do
    case direction do
      v when v in [:north, :east, :south, :west] -> true
      _ -> false
    end
  end

  defp is_valid_position(position) do
    case position do
      {x, y} -> is_number(x) and is_number(y)
      _ -> false
    end
  end

  defp do_robot_step(_step, robot = {:error, _}) do
    {:halt, robot}
  end

  defp do_robot_step(step, robot) when step == "L" do
    {:cont, %RobotSimulator.Robot{robot | cur_direction: turn_right_robot(robot)}}
  end

  defp do_robot_step(step, robot) when step == "R" do
    {:cont, %RobotSimulator.Robot{robot | cur_direction: turn_left_robot(robot)}}
  end

  defp do_robot_step(step, robot) when step == "A" do
    {:cont, %RobotSimulator.Robot{robot | cur_position: advance_robot(robot)}}
  end

  defp do_robot_step(_step, _robot) do
    {:halt, {:error, "invalid instruction"}}
  end

  defp advance_robot(robot) do
    case robot.cur_direction do
      :north -> {elem(robot.cur_position, 0), elem(robot.cur_position, 1) + 1}
      :east -> {elem(robot.cur_position, 0) + 1, elem(robot.cur_position, 1)}
      :south -> {elem(robot.cur_position, 0), elem(robot.cur_position, 1) - 1}
      :west -> {elem(robot.cur_position, 0) - 1, elem(robot.cur_position, 1)}
    end
  end

  defp turn_left_robot(robot) do
    case robot.cur_direction do
      :north -> :east
      :east -> :south
      :south -> :west
      :west -> :north
    end
  end

  defp turn_right_robot(robot) do
    case robot.cur_direction do
      :north -> :west
      :east -> :north
      :south -> :east
      :west -> :south
    end
  end
end
