-- Workspaces configuration (Workspaces 1-4)

for i = 1, 4 do
    hl.workspace_rule({
        workspace = tostring(i),
        default = (i == 1)
    })
end
