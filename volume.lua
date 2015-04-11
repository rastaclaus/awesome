local wibox = require("wibox")
local awful = require("awful")

volume_widget = wibox.widget.textbox()
volume_widget:set_align("right")
volume_widget:set_font("sans 10")

function update_volume(widget)
   local fd = io.popen("amixer sget Master")
   local status = fd:read("*all")
   fd:close()
   local volume = tonumber(string.match(status, "(%d?%d?%d)%%"))
   status = string.match(status, "%[(o[^%]]*)%]")
   if not string.find(status, "on", 1, true) then
       volume = " <span color='red'" .. " Snd: " .. volume.. " </span>"
   else
       volume = " <span>Snd: " .. volume.. " </span>"
   end
   widget:set_markup(volume)
end

update_volume(volume_widget)

mytimer = timer({ timeout = 1 })
mytimer:connect_signal("timeout", function () update_volume(volume_widget) end)
mytimer:start()
