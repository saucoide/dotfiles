import pdb

class Config(pdb.DefaultConfig):
    editor = "nvim"
    sticky_by_default = True
    filename_color = pdb.Color.lightgray
    use_terminal256formatter = False
    # current_line_color = 7

    def setup(self, pdb):
        """Called during Pdb init"""
        pass

