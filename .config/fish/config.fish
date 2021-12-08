# Startup greeting
function fish_greeting
    neofetch
end


# My functions
# ---------------------------------------------------------------------
function ls
 exa --long --classify --color=always --group-directories-first
end

function lsa
 exa --long --all --classify --color=always --group-directories-first
end

function cd..
  cd ..
end
# ---------------------------------------------------------------------


# PROMPT (starship https://github.com/starship/starship)
starship init fish | source
