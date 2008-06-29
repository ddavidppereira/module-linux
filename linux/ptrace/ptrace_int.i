/*
 * Copyright 2008, Google Inc.
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 * 
 *     * Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above
 * copyright notice, this list of conditions and the following disclaimer
 * in the documentation and/or other materials provided with the
 * distribution.
 *     * Neither the name of Google Inc. nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,           
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY           
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 */
%module ptrace_int
%{
#include <sys/ptrace.h>
#include <sys/types.h>
#include <sys/wait.h>


/* Compilation workarounds */
enum __waitpid { __dummy1 = 0};
enum __waitid { __dummy2 = 0};
enum __idtype { __dummy3 = 0};

%}
%include "cpointer.i"

/* Create some functions for working with "int *" */
%pointer_functions(int, intp);

/* Copied from x86_64 specific ptrace.h. It'd be much preferable to
   just include the appropriate header file and have swig do the 
   right thing */
enum __ptrace_request
{
  /* Indicate that the process making this request should be traced.
     All signals received by this process can be intercepted by its
     parent, and its parent can use the other `ptrace' requests.  */
  PTRACE_TRACEME = 0,


  /* Return the word in the process's text space at address ADDR.  */
  PTRACE_PEEKTEXT = 1,


  /* Return the word in the process's data space at address ADDR.  */
  PTRACE_PEEKDATA = 2,


  /* Return the word in the process's user area at offset ADDR.  */
  PTRACE_PEEKUSER = 3,


  /* Write the word DATA into the process's text space at address ADDR.  */
  PTRACE_POKETEXT = 4,


  /* Write the word DATA into the process's data space at address ADDR.  */
  PTRACE_POKEDATA = 5,


  /* Write the word DATA into the process's user area at offset ADDR.  */
  PTRACE_POKEUSER = 6,


  /* Continue the process.  */
  PTRACE_CONT = 7,


  /* Kill the process.  */
  PTRACE_KILL = 8,


  /* Single step the process.
     This is not supported on all machines.  */
  PTRACE_SINGLESTEP = 9,


  /* Get all general purpose registers used by a processes.
     This is not supported on all machines.  */
   PTRACE_GETREGS = 12,


  /* Set all general purpose registers used by a processes.
     This is not supported on all machines.  */
   PTRACE_SETREGS = 13,


  /* Get all floating point registers used by a processes.
     This is not supported on all machines.  */
   PTRACE_GETFPREGS = 14,


  /* Set all floating point registers used by a processes.
     This is not supported on all machines.  */
   PTRACE_SETFPREGS = 15,


  /* Attach to a process that is already running. */
  PTRACE_ATTACH = 16,


  /* Detach from a process attached to with PTRACE_ATTACH.  */
  PTRACE_DETACH = 17,


  /* Get all extended floating point registers used by a processes.
     This is not supported on all machines.  */
   PTRACE_GETFPXREGS = 18,


  /* Set all extended floating point registers used by a processes.
     This is not supported on all machines.  */
   PTRACE_SETFPXREGS = 19,


  /* Continue and stop at the next (return from) syscall.  */
  PTRACE_SYSCALL = 24,


  /* Set ptrace filter options.  */
  PTRACE_SETOPTIONS = 0x4200,


  /* Get last ptrace message.  */
  PTRACE_GETEVENTMSG = 0x4201,


  /* Get siginfo for process.  */
  PTRACE_GETSIGINFO = 0x4202,


  /* Set new siginfo for process.  */
  PTRACE_SETSIGINFO = 0x4203

};

/* Bits in the third argument to `waitpid'.  */
enum __waitpid {
  WNOHANG = 1,          /* Don't block waiting.  */
  WUNTRACED = 2         /* Report status of stopped children.  */
};

enum __idtype {
  P_ALL = 0,            /* Wait for any child.  */
  P_PID,                /* Wait for specified process.  */
  P_PGID                /* Wait for members of process group.  */
}; 

/* Bits in the fourth argument to `waitid'.  */
enum __waittid {
  WSTOPPED = 2,         /* Report stopped child (same as WUNTRACED). */
  WEXITED =  4,         /* Report dead child.  */
  WCONTINUED = 8,       /* Report continued child.  */
  WNOWAIT = 0x01000000, /* Don't reap, just poll status.  */
  
  __WNOTHREAD = 0x20000000, /* Don't wait on children of other threads 
                              in this group */
  __WALL = 0x40000000,  /* Wait for any child.  */
  __WCLONE = 0x80000000, /* Wait for cloned process.  */
};

typedef int pid_t;

long ptrace(enum __ptrace_request request, int pid,
            void *addr, void *data);
pid_t wait(int *status);
pid_t waitpid(pid_t pid, int *status, enum __waitpid options);
int waitid(enum __idtype idtype, id_t id, siginfo_t *infop,
           enum __waitid options);

%typemap(out) int {
  if (result == -1) {
    PyErr_SetFromErrno(PyExc_OSError);
    SWIG_fail;
  }
  resultobj = SWIG_From_int((int)(result));
};

