import os, osproc, strutils, sequtils, strformat
import utils
import argparse
import sugar

let config = expandTilde("~/.config/cmder/cmd.csv")
let splitChar = ","

type
  ConfigItem = ref object
    description: string
    command: string

proc parseConfigLine(x:string): ConfigItem =
  let line = x.split(splitChar)
  return ConfigItem(description : line[0], command : line[1])

proc parseConfig(): seq[ConfigItem] =
  return config
    .readfile
    .strip()
    .splitLines()
    .map(parseConfigLine)

proc exec(x: string, config = parseConfig()) =
  let y = config
    .findIt(it.description == x)
  echo y.command

proc main() =
  let config = parseConfig()
  let items = config
    .mapIt(it.description)
    .join("\n")
  let response = execProcess(&"echo '{items}'| rofi -i -levenshtein-sort -dmenu -p \"Run\"").replace("\n", "")
  let item = config.findIt(it.description == response)
  discard execShellCmd(item.command)

var p = newParser("cmder"):
  command("main"):
    run:
      main()
  command("exec"):
    arg("cmd")
    run:
      exec(opts.cmd)

p.run()
