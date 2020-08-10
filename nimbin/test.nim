import fp/either
import fp/option
import fp/trym except run
import sugar
import times
import strformat
import os

let defaultCacheDir = expandTilde "/tmp/nim-timer"
let fileFormat = initTimeFormat("yyyy-MM-dd-hh:mm-ss")

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


echo createTimerFile("foooooo".some, "bar")
