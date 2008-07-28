/*
 * Copyright 2007, Google Inc.
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
%module sched_int
%{
#include <sched.h>
%}

/* Data structure to describe CPU mask.  */
typedef struct
{
  __cpu_mask __bits[__CPU_SETSIZE / __NCPUBITS];
} cpu_set_t;


%extend cpu_set_t {
  void set(int i) {
    CPU_SET(i, self);
  }

  void clear_mask(int i) {
    CPU_CLR(i, self);
  }

  int test(int i) {
    return CPU_ISSET(i, self);
  }

  void zero() {
    CPU_ZERO(self);
  }
}

%typemap(out) int {
  if (result == -1) {
    PyErr_SetFromErrno(PyExc_OSError);
    SWIG_fail;
  }
  resultobj = SWIG_From_int((int)(result));
};

%inline %{
int getaffinity(int pid, cpu_set_t *mask) {
  return sched_getaffinity(pid, sizeof(cpu_set_t), mask);
}

int setaffinity(int pid, const cpu_set_t *mask) {
  return sched_setaffinity(pid, sizeof(cpu_set_t), mask);
}

int getcpu() {
  return sched_getcpu();
}
%}
