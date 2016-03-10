package.path = '/usr/local/share/lua/5.3/?.lua;/usr/local/share/lua/5.3/?/init.lua;'..package.path
package.cpath = '/usr/local/lib/lua/5.3/?.so;'..package.cpath

hs.hotkey.bind('shift alt ctrl', 'r', 'Reload Hammerspoon config', function()
    hs.reload()
end)

require 'moonscript'
require 'main'
