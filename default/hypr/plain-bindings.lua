require("default.hypr.bindings.media")
require("default.hypr.bindings.clipboard")
require("default.hypr.bindings.tiling-v2")
require("default.hypr.bindings.utilities")

-- Application bindings without Omarchx's preinstalled web apps, TUIs, or desktop apps.
o.bind("SUPER + RETURN", "Terminal", { omarchx = "terminal" })
o.bind("SUPER + SHIFT + RETURN", "Browser", { omarchx = "browser" })
o.bind("SUPER + SHIFT + F", "File manager", { omarchx = "nautilus" })
o.bind("SUPER + ALT + SHIFT + F", "File manager (cwd)", { omarchx = "nautilus-cwd" })
o.bind("SUPER + SHIFT + B", "Browser", { omarchx = "browser" })
o.bind("SUPER + SHIFT + ALT + B", "Browser (private)", { omarchx = "browser --private" })
o.bind("SUPER + SHIFT + N", "Editor", { omarchx = "editor" })
