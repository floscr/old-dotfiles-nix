import os,
       osproc,
       strutils,
       sequtils,
       strformat,
       options
import utils
import argparse
import sugar

let config = expandTilde("~/.config/cmder/cmd.csv")
let splitChar = ",,,"

type
  ConfigItem = ref object
    description: string
    command: string
    binding: Option[string]

proc commands*(xs: seq[ConfigItem]): string =
  xs
    .mapIt(it.description)
    .join("\n")

proc parseConfigLine(x:string): ConfigItem =
  let line = x.split(splitChar)
  return ConfigItem(
    description : line[0],
    command : line[1],
    binding : optionIndex(line, 2),
  )

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
  let response = execProcess(&"echo '{config.commands()}'| rofi -i -levenshtein-sort -dmenu -p \"Run\"").replace("\n", "")
  if response != "":
    let item = config.findIt(it.description == response)
    discard execShellCmd(item.command)

var p = newParser("cmder"):
  command("items"):
    run:
      parseConfig().commands() |> echo
  command("main"):
    run:
      main()
  command("exec"):
    arg("cmd")
    run:
      exec(opts.cmd)

p.run()
