import argparse
import fp/option
import fp/trym except run
import json
import lib/optionUtils
import macros
import os
import osproc
import regex
import sequtils
import strformat
import strutils
import sugar
import times
import utils

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

# proc parseDateString(str: string): Duration =
#   var m: RegexMatch
#   discard str.match(re"((?P<hours>\d*)h)? ?((?P<minutes>\d*)m)? ?((?P<seconds>\d*)s)?", m)
#   let ms  =[
#     "hours",
#     "minutes",
#     "seconds",
#   ]
#   .map(x => tryM(m.group(x, str)[0])
#     .map(y => y.parseInt())
#     .getOrElse(0)
#   )
#   initDuration(hours = ms[0], minutes = ms[1], seconds = ms[2])


# proc createTimer(name: string, time.string): string =
#   createDir(defaultCacheDir)
#   TimerData(
#     name
#   )

proc listTimers(showAll: bool): string =
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

import argparse

var p = newParser("My Program"):
  command("list"):
    flag("-a", "--all")
    run:
      echo listTimers(opts.all)
  #     createTimer(opts.name, opts.time) |> echo

p.run()

# echo (now() - 1.hours).format(iso8601format)
