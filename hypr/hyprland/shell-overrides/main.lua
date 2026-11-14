-- Shell overrides for Quickshell integration
-- Blur, ignore mouse input settings and layer rules for Quickshell panels

hl.layer_rule({ match = { namespace = "quickshell:.*" }, xray = true })
hl.layer_rule({ match = { namespace = "quickshell:overlay" }, no_anim = true, ignore_alpha = 1 })
hl.layer_rule({ match = { namespace = "quickshell:session" }, blur = true, no_anim = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "quickshell:sidebar.*" }, blur = true })
hl.layer_rule({ match = { namespace = "quickshell:panel.*" }, blur = true })
