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
    result = "File written".right(string)
  except IOError:
    result = ("Could not write file \n" & getCurrentExceptionMsg()).left(string)

proc createTimerFile(name: Option[string], content: string): any =
  let path = name
    .orElse(() => now().format(fileFormat).some)
    .map(x => &"{x}.json")
    .map(x => joinPath(defaultCacheDir, x))

  discard tryE()
  # fromEither(tryET do: writeFile(path.get, content))


echo writeFileEither("/tmp/faaaa/sfdsffd/sdfsf", "bar")
