-- Core window and workspace rules

-- Default behavior: all windows floating
hl.window_rule({
    match = { class = ".*" },
    float = true,
})

-- Common dialogs and utility windows always centered and floating
hl.window_rule({ match = { title = "^(Open File)(.*)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(Select a File)(.*)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(Choose wallpaper)(.*)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(Open Folder)(.*)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(Save As)(.*)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(Library)(.*)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(File Upload)(.*)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(.*)(wants to save)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(.*)(wants to open)$" }, center = true, float = true })

hl.window_rule({ match = { class = "^(pavucontrol)$" }, float = true, center = true })
hl.window_rule({ match = { class = "^(org.pulseaudio.pavucontrol)$" }, float = true, center = true })
hl.window_rule({ match = { class = "^(nm-connection-editor)$" }, float = true, center = true })

-- Picture-in-Picture
hl.window_rule({ match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" }, float = true, pin = true, keep_aspect_ratio = true })

-- Screen sharing indicator
hl.window_rule({ match = { title = ".*is sharing (a window|your screen).*" }, float = true, pin = true })

-- No shadow for any window
hl.window_rule({ match = { class = ".*" }, no_shadow = true })

-- Workspace definitions (Workspaces 1-4)
for i = 1, 4 do
    hl.workspace_rule({ workspace = tostring(i) })
end

-- Layer rules
hl.layer_rule({ match = { namespace = ".*" }, xray = true })
hl.layer_rule({ match = { namespace = "selection" }, no_anim = true })
hl.layer_rule({ match = { namespace = "overview" }, no_anim = true })
hl.layer_rule({ match = { namespace = "hyprpicker" }, no_anim = true })
