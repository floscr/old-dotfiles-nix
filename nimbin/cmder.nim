import os, strutils, sequtils, strformat
import utils
import argparse
import sugar

let config = "/home/floscr/.config/cmder/cmd.csv"
let splitChar = ","

type
  ConfigItem = ref object
    description: string
    command: string

proc parseConfigLine(x:string): ConfigItem =
  let line = x.split(splitChar)
  return ConfigItem(description : line[0],
             command : line[1],
  )

proc parseConfig(): seq[ConfigItem] =
  return config
    .readfile
    .strip()
    .splitLines()
    .map(parseConfigLine)

proc exec(x: string) =
  let y = parseConfig()
    .findIt(it.description == x)
  echo y.command

proc main() =
  let items = parseConfig()
    .mapIt(it.description)
    .join("\n")
  discard execShellCmd(&"echo \"{items}\" | rofi -i -dmenu -p \"Run\" ")

var p = newParser("cmder"):
  command("main"):
    run:
      main()
  command("exec"):
    arg("cmd")
    run:
      exec(opts.cmd)

p.run()
