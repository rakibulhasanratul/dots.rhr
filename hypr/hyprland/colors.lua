-- Theme colors & border palette

hl.config({
    general = {
        col = {
            active_border   = "rgba(0db7d4ff)",
            inactive_border = "rgba(313136aa)",
        },
    },
    misc = {
        background_color = "rgba(121318ff)",
    },
})

hl.window_rule({
    match        = { pin = 1 },
    border_color = "rgba(afc6ffaa) rgba(afc6ff77)",
})
