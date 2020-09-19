import fp/option
import fp/trym except run
import json
import optionUtils
import os
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

method endsInSec(data: TimerData): Duration =
  now() - data.endTime

method toStr(data: TimerData): string =
  let diff = (data.endTime - now()).toParts()
  &"""Name: {data.name}
Start: {data.startTime.format(readableFormat)}
End: {data.endTime.format(readableFormat)}
Time Left: {diff[Minutes]:02}:{diff[Seconds]:02}"""

proc writeFileEither(name: string, content: string): EitherS[string] =
  try:
    writeFile(name, content)
    "File written".right(string)
  except IOError:
    ("Could not write file \n" & getCurrentExceptionMsg()).left(string)

proc createTimerFile(name: Option[string], content: string): EitherS[string] =
  let filename = name
    .orElse(() => now().format(fileFormat).some)
    .map(x => &"{x}.json")
    .map(x => joinPath(defaultCacheDir, x))

  writeFileEither(filename.get, content)

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

# proc createTimer(name: Option(string)): string =
#   discard createDir(defaultCacheDir)
#   let name = name
#     .map(parseDateString)

proc listTimers*(showAll: bool): string =
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
