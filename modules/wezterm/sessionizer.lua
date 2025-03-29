-- ~.config/wezterm/sessionizer.lua
local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local fd = "/etc/profiles/per-user/" .. os.getenv("USER") .."/bin/fd"
local fish = "/etc/profiles/per-user/" .. os.getenv("USER") .."/bin/fish"

local get_parent_directory = function(path)
  path = path:gsub("/$", "") -- remove trailing /
  local lastSeparator = path:match(".*[/]")
  if lastSeparator then
    return lastSeparator:sub(1, -2)
  else
    return "."
  end
end

M.toggle = function(window, pane)
  local projects = {}
  local seen_projects = {}

  local project_markers = { "^.git$", "^pyproject.toml$", "^.project_root$" }
  local regex_pattern = "^(" .. table.concat(project_markers, "|") .. ")$"

  local success, stdout, stderr = wezterm.run_child_process({
    fd,
    "-HI",
    regex_pattern,
    "--max-depth=5",
    "--prune",
    os.getenv("HOME") .. "/projects",
    os.getenv("HOME") .. "/projects/analytics/gke-jobs",
    os.getenv("HOME") .. "/dotfiles",
    os.getenv("HOME") .. "/.config"

  })
  if not success then
    wezterm.log_error("Failed to run fd: " .. stderr)
    return
  end

  for line in stdout:gmatch("([^\n]+)") do
    local project = get_parent_directory(line)
    if not seen_projects[project] then
      seen_projects[project] = true
      -- local label = project

      local parent, last = project:match("(.*/)([^/]+)$")
      if not parent then
        parent = ""
        last = project
      end

      local label = wezterm.format {
            { Foreground = { AnsiColor = 'Grey' } },
            { Text = parent },
            { Foreground = { AnsiColor = 'Green' } },
            { Attribute = { Intensity = "Bold" } },
            { Text = last },
          }

      table.insert(projects, { label = label, id = tostring(project) })
    end
  end

  window:perform_action(
    act.InputSelector({
      action = wezterm.action_callback(function(win, _, id, label)
        if not id and not label then
          wezterm.log_info("Cancelled")
        else
          wezterm.log_info("Selected " .. label)
          win:perform_action(
            act.SwitchToWorkspace({ name = id, spawn = { cwd = id } }),
            pane
          )
        end
      end),
      fuzzy = true,
      title = "Select project: ",
      fuzzy_description = wezterm.format {
            { Foreground = { AnsiColor = 'Blue' } }, {Text = "Select project: "}
      },

      choices = projects,
    }),
    pane
  )
end


return M
