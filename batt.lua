local wibox = require("wibox")
local awful = require("awful")

 battery_widget = wibox.widget.textbox()
 battery_widget:set_align("right")
 battery_widget:set_font("sans 10")

 function batteryInfo(adapter)
     spacer = " "
     local fcur = io.open("/sys/class/power_supply/"..adapter.."/charge_now")    
     local fcap = io.open("/sys/class/power_supply/"..adapter.."/charge_full")
     local fsta = io.open("/sys/class/power_supply/"..adapter.."/status")
     local cur = fcur:read()
     local cap = fcap:read()
     local sta = fsta:read()
     local battery = math.floor(cur * 100 / cap)
     if sta:match("Charging") then
         dir = "+"
     elseif sta:match("Discharging") then
         dir = "-"
         if tonumber(battery) > 25 and tonumber(battery) < 75 then
             battery = battery
         elseif tonumber(battery) < 25 then
             if tonumber(battery) < 10 then
                 naughty.notify({ title      = "Battery Warning"
                                , text       = "Battery low!"..spacer..battery.."%"..spacer.."left!"
                                , timeout    = 5
                                , position   = "top_right"
                                , fg         = beautiful.fg_focus
                                , bg         = beautiful.bg_focus
                                })
             end
             battery = battery
         else
             battery = battery
         end
     else
         dir = "+"
     end
     battery_widget:set_markup(spacer.."Bat:"..spacer..dir..battery..dir..spacer)
     fcur:close()
     fcap:close()
     fsta:close()
 end
batteryInfo("BAT1")
battery_timer = timer({timeout = 20})
battery_timer:connect_signal("timeout", function()
    batteryInfo("BAT1")
  end)
battery_timer:start()
