#!/usr/bin/env python

from distutils.core import setup, Extension
from distutils.command.install_data import install_data

setup(name='module-linux',
      version='0.1',
      author='Arun Sharma',
      author_email='arun.sharma@google.com',
      description='Linux syscalls wrapper',
      packages=['linux', 'linux.sched', 'linux.ptrace', 'linux.syscall' ],
      ext_modules=[Extension('linux.sched._sched_int',
                             extra_compile_args=['-D_GNU_SOURCE'],
                             sources=['linux/sched/sched_int.i']),
                   Extension('linux.ptrace._ptrace_int',
                             extra_compile_args=['-D_GNU_SOURCE'],
                             sources=['linux/ptrace/ptrace_int.i']),
                   Extension('linux.syscall._syscall_int',
                             extra_compile_args=['-D_GNU_SOURCE'],
                             sources=['linux/syscall/syscall_int.i'])])
