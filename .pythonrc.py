# Generated from ~/dotfiles/system.org
import importlib
from functools import partial
import json
import itertools

try:
    from rich import inspect, pretty, print, traceback
    rich_enabled = True
except ImportError:
    rich_enabled = False

try:
    from wat import wat
except ImportError:
    pass
    
def setup_rich():
    if rich_enabled:
        help = partial(inspect, help=True)
        pretty.install()
        traceback.install()
    
    
def setup_ipython():
    if not (hasattr(__builtins__, '__IPYTHON__') and rich_enabled):
        return
    from IPython import get_ipython
    from IPython.core.magic import (
        Magics,
        line_magic,
        magics_class,
    )

    @magics_class
    class CustomMagics(Magics):
        def _get_var_ref(self, line):
            var_name = line.strip()
            if var_name in self.shell.user_ns:
                return self.shell.user_ns[var_name]

        @line_magic
        def pinfo(self, line):
            """Overwrite ipython's pinfo (= ?)"""
            var_ref = self._get_var_ref(line)
            if var_ref:
                return inspect(var_ref, help=True)
            else:
                return f"Object '{line.strip()}' not found."

        @line_magic
        def pinfo2(self, line):
            """Overwrite ipython's pinfo2 (= ??)"""
            var_ref = self._get_var_ref(line)
            if var_ref:
                return inspect(var_ref, help=True, methods=True, docs=True)
            else:
                return f"Object '{line.strip()}' not found."

        @line_magic
        def h(self, line):
            """add a %h magic to print ALL"""
            var_ref = self._get_var_ref(line)
            if var_ref:
                return inspect(var_ref, all=True, sort=False)
            else:
                return f"Object '{line.strip()}' not found."

    if rich_enabled:
        get_ipython().register_magics(CustomMagics)


def setup_examples():
    global alist
    global adict
    alist = ["a", "b", "c", "d"]
    adict = {"a": 1, "b": 2, "c": 3, "d": 4}


setup_rich()
setup_ipython()
setup_examples()
