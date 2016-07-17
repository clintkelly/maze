# MazeWalls

Implement maze algorithms, but use the approach from _Clojure Programming_ in which we model only
the walls between cells (and don't recreate an entire grid with lots of state and so on).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add maze_walls to your list of dependencies in `mix.exs`:

        def deps do
          [{:maze_walls, "~> 0.0.1"}]
        end

  2. Ensure maze_walls is started before your application:

        def application do
          [applications: [:maze_walls]]
        end

