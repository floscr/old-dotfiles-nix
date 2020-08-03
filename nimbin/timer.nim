import os, osproc, strutils, sequtils, strformat
import json
import utils
import argparse
import sugar
import times
import macros
import fp/option
import lib/optionUtils

# let cacheDir = "nim_timer"
# let defaultCacheDir = joinPath(getEnv("XDG_CACHE_HOME", "/tmp"), cacheDir)
let defaultCacheDir = expandTilde "/tmp/nim-timer"
let iso8601format = initTimeFormat("yyyy-MM-dd'T'hh:mm:sszzz")
let readableFormat = initTimeFormat("yyyy-MM-dd - hh:mm:ss")

type
  TimerData = ref object
    name: string
    startTime: DateTime
    endTime: DateTime

method fromJson(data: JsonNode): TimerData =
  TimerData(
    name: data["name"].getStr(),
    startTime: data["start"].getStr().parse(iso8601format),
    endTime: data["end"].getStr().parse(iso8601format),
  )

method endsInSec(data: TimerData): Duration =
  now() - data.endTime

method toStr(data: TimerData): string =
  let diff = (data.endTime - now()).toParts()
  &"""Name: {data.name}
Start: {data.startTime.format(readableFormat)}
End: {data.endTime.format(readableFormat)}
Time Left: {diff[Minutes]:02}:{diff[Seconds]:02}"""

proc readDir(): seq[TimerData] =
  toSeq(walkDir(defaultCacheDir, true))
    .map(c => joinPath(defaultCacheDir, c.path) |> readFile |> parseJson |> fromJson)

proc list(showAll: bool): string =
  readDir()
    .some
    .mapWhen(
      xs => not(showAll),
      xs => xs.filterIt(it.endTime > now()),
    )
    .map(xs => xs
         .mapIt(it.toStr)
         .join("\n")
    )
    .getOrElse("")

var p = newParser("cmder"):
  command("list"):
    flag("-a", "--all")
    run:
      list(opts.all) |> echo

p.run()

# echo (now() - 1.hours).format(iso8601format)
