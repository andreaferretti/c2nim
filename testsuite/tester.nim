# Small program that runs the test cases

import strutils, os

const
  c2nimCmd = "c2nim $#"
  cpp2nimCmd = "c2nim --cpp $#"
  dir = "testsuite/"

var
  failures = 0

proc test(t, cmd: string) =
  if execShellCmd(cmd % t) != 0: quit("FAILURE")
  let nimFile = splitFile(t).name & ".nim"
  if strip(readFile(dir & "tests" / nimFile).replace("\C\L", "\L")) !=
     strip(readFile(dir & "results" / nimFile).replace("\C\L", "\L")):
    echo "FAILURE: files differ: ", nimFile
    discard execShellCmd("diff -uNdr " & dir & "results" / nimFile & " " & dir & "tests" / nimFile)
    failures += 1
  else:
    echo "SUCCESS: files identical: ", nimFile

for t in walkFiles(dir & "tests/*.c"): test(t, c2nimCmd)
for t in walkFiles(dir & "tests/*.h"): test(t, c2nimCmd)
for t in walkFiles(dir & "tests/*.cpp"): test(t, cpp2nimCmd)

if failures > 0: quit($failures & " failures occurred.")
