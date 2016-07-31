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

## Weirdness

I have found that sometimes `mix` does not compile the `AnyGrid` protocol properly when I run tests.
Very strange! So sometimes I have to run `mix test` twice. The time produces an error, the second
time works:

    in /Users/clint_kelly/play/elixir/maze_walls/ on master
    › mix test
    Compiling 1 file (.ex)
    ** (EXIT from #PID<0.46.0>) an exception was raised:
        ** (MatchError) no match of right hand side value: {:error, :no_beam_info}
            (mix) lib/mix/tasks/compile.protocols.ex:123: Mix.Tasks.Compile.Protocols.consolidate/4
            (elixir) lib/task/supervised.ex:94: Task.Supervised.do_apply/2
            (elixir) lib/task/supervised.ex:45: Task.Supervised.reply/5
            (stdlib) proc_lib.erl:240: :proc_lib.init_p_do_apply/3

    16:10:50.356 [error] Task #PID<0.85.0> started from #PID<0.46.0> terminating
    ** (MatchError) no match of right hand side value: {:error, :no_beam_info}
        (mix) lib/mix/tasks/compile.protocols.ex:123: Mix.Tasks.Compile.Protocols.consolidate/4
        (elixir) lib/task/supervised.ex:94: Task.Supervised.do_apply/2
        (elixir) lib/task/supervised.ex:45: Task.Supervised.reply/5
        (stdlib) proc_lib.erl:240: :proc_lib.init_p_do_apply/3
    Function: #Function<8.10854390/0 in Mix.Tasks.Compile.Protocols.consolidate/6>
        Args: []

    in /Users/clint_kelly/play/elixir/maze_walls/ on master
    › mix test
    .....................................

    Finished in 1.2 seconds
    37 tests, 0 failures

    Randomized with seed 945302

    in /Users/clint_kelly/play/elixir/maze_walls/ on master
    ›

¯\_(ツ)_/¯
