#!/usr/bin/env python

import linux.sched
from linux.ptrace import *
import subprocess

# run f on cpu n
def run_on_cpu(n, f):
   mask = linux.sched.cpu_set_t()
   mask.zero()
   oldmask = linux.sched.cpu_set_t()
   linux.sched.getaffinity(0, oldmask)
   # Bind to logical cpu n
   mask.set(n)
   linux.sched.setaffinity(0, mask)
   f()
   # Restore old mask
   linux.sched.setaffinity(0, oldmask)

def hello():
  print "hello world"

if __name__ == '__main__':
  run_on_cpu(1, hello)
  p = subprocess.Popen(["/usr/bin/sleep", "10"])
  ptrace(PTRACE_ATTACH, p.pid)
  print "Attached: ", p.pid
  print waitpid(p.pid, WUNTRACED);
  ptrace(PTRACE_DETACH, p.pid)
  print "Detached: ", p.pid


