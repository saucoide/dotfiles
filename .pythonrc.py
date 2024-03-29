from importlib import util
from functools import partial


try:
    # make ipython pretty
    if __IPYTHON__ and util.find_spec("rich"):
        from rich import inspect, pretty, print, traceback
        from IPython import get_ipython
        from IPython.core.magic import (
            Magics,
            line_magic,
            magics_class,
        )

        # rich pretty printers
        help = partial(inspect, help=True)
        pretty.install()
        traceback.install()

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

        get_ipython().register_magics(CustomMagics)
except NameError:
    pass
