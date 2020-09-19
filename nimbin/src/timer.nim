import argparse
import lib/utils
import lib/timer

var p = newParser("My Program"):
  command("list"):
    flag("-a", "--all")
    run:
      listTimers(opts.all) |> echo
  command("in"):
    arg("time", help="", default="")
    run:
      opts.time |> parseDateString |> echo

p.run()
