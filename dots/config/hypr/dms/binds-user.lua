-- DMS user keybind overrides (edit via Control Center or dms; do not remove this header)

hl.unbind("SUPER + D")
hl.bind("SUPER + D", hl.dsp.exec_cmd("dms ipc call spotlight toggle"), { description = "Default Launcher: Toggle" })
hl.unbind("Print")
