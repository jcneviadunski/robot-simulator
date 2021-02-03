defmodule RobotSimulator.Robot do
  @enforce_keys [:cur_direction, :cur_position]

  defstruct [:cur_direction, :cur_position]
end
