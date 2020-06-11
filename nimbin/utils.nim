template findIt*(coll, cond): untyped =
  var res: typeof(coll.items, typeOfIter)
  for it {.inject.} in coll:
    if not cond: continue
    res = it
    break
  res
