import os, osproc, strutils, sequtils, strformat
import utils
import argparse
import sugar

# let cacheDir = "nim_timer"
# let defaultCacheDir = joinPath(getEnv("XDG_CACHE_HOME", "/tmp"), cacheDir)
let defaultCacheDir = expandTilde("~/Desktop/Foo")

proc list() =
  let files = toSeq(walkDir(defaultCacheDir, true))
    .map((c) => joinPath(defaultCacheDir, c.path) |> getFileInfo)
  echo files

var p = newParser("cmder"):
  command("list"):
    run:
      list()

p.run(@["list"])
