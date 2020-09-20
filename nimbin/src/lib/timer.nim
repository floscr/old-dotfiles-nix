import fp/option
import fp/list
import fp/trym except run
import json
import optionUtils
import os
import osproc
import regex
import sequtils
import strformat
import strutils
import sugar
import times
import utils
import fpUtils

let defaultCacheDir = "/tmp/nim-timer"
let iso8601format = initTimeFormat("yyyy-MM-dd'T'hh:mm:sszzz")
let readableFormat = initTimeFormat("yyyy-MM-dd - hh:mm:ss")
let fileFormat = initTimeFormat("yyyy-MM-dd-hh:mm-ss")

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

method toJson(data: TimerData): JsonNode =
  %* {
    "name": data.name,
    "start": data.startTime.format(iso8601format),
    "end": data.endTime.format(iso8601format),
  }

method endsInSec(data: TimerData): Duration =
  now() - data.endTime

method toStr(data: TimerData): string =
  let diff = (data.endTime - now()).toParts()
  [
    data.name.some
      .notEmpty
      .map(x => &"Name: {x}"),
    fmt"Start: {data.startTime.format(readableFormat)}".some,
    fmt"End: {data.endTime.format(readableFormat)}".some,
    fmt"Time Left: {diff[Minutes]:02}:{diff[Seconds]:02}".some,
  ]
  .filter(x => x.isDefined)
  .map(x => x.get)
  .join("\n")

proc writeFileEither(name: string, content: string): EitherS[string] =
  try:
    writeFile(name, content)
    "File written".right(string)
  except IOError:
    ("Could not write file \n" & getCurrentExceptionMsg()).left(string)

proc createTimerFile(name: Option[string], content: string): Either[string, string] =
  let filename = name
    .orElse(() => now().format(fileFormat).some)
    .map(x => &"{x}.json")
    .map(x => joinPath(defaultCacheDir, x))

  writeFileEither(filename.get, content)
    .fold(
      x => x.left(string),
      x => x.right(string),
    )

proc readDir(): seq[TimerData] =
  toSeq(walkDir(defaultCacheDir, true))
    .map(c => joinPath(defaultCacheDir, c.path) |> readFile |> parseJson |> fromJson)

proc parseDateString*(str: string): Duration =
  var m: RegexMatch
  discard str.match(re"((?P<hours>\d*)h(ours?)?)? ?((?P<minutes>\d*)m(inutes?)?)? ?((?P<seconds>\d*)s(econds?)?)?", m)
  let ms  =[
    "hours",
    "minutes",
    "seconds",
  ]
  .map(x => tryM(m.group(x, str)[0])
    .map(y => y.parseInt())
    .getOrElse(0)
  )
  initDuration(hours = ms[0], minutes = ms[1], seconds = ms[2])

proc runTimerIn*(time: seq[string]): Either[string, string] =
  createDir(defaultCacheDir)

  let now = now()

  let json = time
    .asList
    .headOption
    .asEither("No duration")

    # parse
    .map(parseDateString)
    .map(x => now + x)

    # Create json
    .map(x => TimerData(
      name: "",
      startTime: now,
      endTime: x,
    ))
    .map(x => x.toJson().pretty())

    .flatMap((x: string) => createTimerFile(string.none, x))

  json

proc runTimerList*(showAll: bool): string =
  readDir()
    .some
    .mapWhen(
      xs => not(showAll),
      xs => xs.filterIt(it.endTime < now()),
    )
    .map(xs => xs
         .mapIt(it.toStr)
         .join("\n")
    )
    .getOrElse("")
