import options
import os
import osproc
import sequtils
import strformat
import strutils
import utils
import fp/list
import regex
import sugar

proc parseId(str: string): string =
  var m: RegexMatch
  discard str.match(re" *(?P<id>[0-9a-z]*).*", m)
  m.group("id", str)[0]

proc focusedId(): string =
  execProcess("echo \"0x0$(printf '%x\n' $(xdotool getwindowfocus))\"")
  .replace("\n", "")

proc xids(): List[string] =
  execProcess("xwininfo -root -children")
  .split("\n")
  .asList
  .drop(6)
  .filter(x => x != "")
  .map(parseId)

proc scratchWindows(): List[string] =
  xids()
  .map(x => execProcess(&"xprop -id {x} _SCRATCH"))

proc makeScratchWindow(): any =
  discard startProcess("termite")

echo "~/.nix-profile/bin/termite"
.some
.map(expandTilde)
.map(x => &"{x} -t TerminalScratchpad")
.get

# discard startProcess(("~/.nix-profile/bin/termite"))

# makeScratchWindow()
# echo focusedId()
