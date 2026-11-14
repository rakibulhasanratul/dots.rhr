-- Shared Lua library & Hyprland config builder (hl) helper definitions

HOME = os.getenv("HOME") or ""

-- If running under pure standalone Lua (e.g. for validation/testing outside Hyprland runtime),
-- provide fallback stubs for Hyprland's built-in `hl` API so modules load cleanly and pass assertions.
if not hl then
    local dsp_window = {
        close = function(...) return { action = "close", args = {...} } end,
        kill = function(...) return { action = "kill", args = {...} } end,
        float = function(...) return { action = "float", args = {...} } end,
        fullscreen = function(...) return { action = "fullscreen", args = {...} } end,
        move = function(...) return { action = "move", args = {...} } end,
        cycle_next = function(...) return { action = "cycle_next", args = {...} } end,
        movefocus = function(...) return { action = "movefocus", args = {...} } end,
        drag = function(...) return { action = "drag", args = {...} } end,
        resize = function(...) return { action = "resize", args = {...} } end,
    }

    local dsp_workspace = {
        move = function(...) return { action = "workspace.move", args = {...} } end,
        toggle_special = function(...) return { action = "workspace.toggle_special", args = {...} } end,
    }

    local dsp = {
        window = dsp_window,
        workspace = dsp_workspace,
        exec_cmd = function(cmd, rules) return { action = "exec_cmd", cmd = cmd, rules = rules } end,
        global = function(...) return { action = "global", args = {...} } end,
        focus = function(...) return { action = "focus", args = {...} } end,
        dpms = function(...) return { action = "dpms", args = {...} } end,
    }

    hl = {
        dsp = dsp,
        config = function(...) end,
        env = function(...) end,
        bind = function(...) end,
        window_rule = function(t)
            return {
                set_enabled = function() end,
                is_enabled = function() return true end,
            }
        end,
        layer_rule = function(...) end,
        workspace_rule = function(...) end,
        monitor = function(...) end,
        gesture = function(...) end,
        curve = function(...) end,
        animation = function(...) end,
        dispatch = function(...) end,
        on = function(evt, fn) end,
        exec_cmd = function(...) end,
        get_active_window = function() return nil end,
        get_active_workspace = function() return { id = 1 } end,
    }
end

function is_file_exists(name)
   local f = io.open(name, "r")
   if f ~= nil then
      io.close(f)
      return true
   else
      return false
   end
end

function create_if_not_exists(path)
   if not is_file_exists(path) then
      os.execute("mkdir -p \"$(dirname \"" .. path .. "\")\"")
      os.execute("echo '-- Custom user overrides file\n-- This file will not be overwritten\n' > \"" .. path .. "\"")
      return true
   end
   return false
end

function workspace_in_group(i)
    local curr = 1
    if hl and hl.get_active_workspace then
        local ws = hl.get_active_workspace()
        if ws and ws.id then
            curr = ws.id
        end
    end
    local groupSize = workspaceGroupSize or 4
    local newVal = math.floor((curr - 1) / groupSize) * groupSize + i
    return newVal
end
