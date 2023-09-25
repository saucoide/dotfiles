from functools import partial

try:
    from rich import inspect, pretty, print
    help = partial(inspect, help=True)
    pretty.install()
except:
    pass
