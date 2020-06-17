import os, osproc, strutils, sequtils, strformat
import utils
import argparse
import sugar

let mailDir = expandTilde("~/.mail")
let accounts = ["Work/Inbox/new"]

proc newCount() =
  let files = accounts
    .map((x) => joinPath(mailDir, x))
    .map((x) => walkDir(x, true) |> toSeq |> len)
    .foldl(a + b)
    
  echo files

var p = newParser("mail"):
  command("newCount"):
    run:
      newCount()

p.run(@["newCount"])
