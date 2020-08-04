import regex
import fp/trym
import fp/list
import sugar
import strutils
import sequtils
import times

proc parseDateString(x: string): any =
  var m: RegexMatch
  discard x.match(re"((?P<hours>\d*)h)?((?P<minutes>\d*)m)?", m)
  let ms  =[
    tryM(m.group("hours", x)[0]),
    tryM(m.group("minutes", x)[0]),
  ]
  .map(x => x
    .map(y => y.parseInt())
    .getOrElse(0)
   )
  initDuration(hours = ms[0], minutes = ms[1])

echo parseDateString "10h20m"
