-- Git status indicators
require("git"):setup { order = 1500 }

-- Show symlink target in status bar (right side)
Status:children_add(function(self)
	local h = self._current.hovered
	if h and h.link_to then
		return ui.Line {
			ui.Span(" -> " .. tostring(h.link_to)):fg("cyan"),
		}
	end
	return ui.Line {}
end, 3500, Status.RIGHT)
