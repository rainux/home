window = hs.window
mouse = hs.mouse
moon = require 'moon'
logger = hs.logger.new('main', 'verbose')

window.animationDuration = 0

bind = (keys, message, fn) ->
    if message == nil or type(message) == 'function'
        -- Shift down arguments
        fn = message
        message = nil

    mods = hs.fnutils.split(keys, '%s+')
    key = table.remove(mods, rawlen(mods))
    hs.hotkey.bind(mods, key, message, fn)

bind 'cmd H', ->
    hs.hints.windowHints()

bind 'shift alt F', 'Maximize window', ->
    window.focusedWindow()\maximize()

bind 'shift alt K', 'Move window to North screen', ->
    hs.window.focusedWindow()\moveOneScreenNorth()

bind 'shift alt J', 'Move window to South screen', ->
    window.focusedWindow()\moveOneScreenSouth()

bind 'alt ctrl K', 'Move mouse pointer to North screen', ->
    currentScreen = mouse.getCurrentScreen()
    northScreen = currentScreen\toNorth()
    return unless northScreen

    point = mouse.getRelativePosition()
    point = {
        x: point.x * (northScreen\fullFrame().w / currentScreen\fullFrame().w)
        y: point.y * (northScreen\fullFrame().h / currentScreen\fullFrame().h)
    }
    mouse.setRelativePosition(point, northScreen)
    hs.eventtap.leftClick(mouse.getAbsolutePosition())

bind 'alt ctrl J', 'Move mouse pointer to South screen', ->
    currentScreen = mouse.getCurrentScreen()
    southScreen = currentScreen\toSouth()
    return unless southScreen

    point = mouse.getRelativePosition()
    point = {
        x: point.x * (southScreen\fullFrame().w / currentScreen\fullFrame().w)
        y: point.y * (southScreen\fullFrame().h / currentScreen\fullFrame().h)
    }
    mouse.setRelativePosition(point, southScreen)
    hs.eventtap.leftClick(mouse.getAbsolutePosition())

bind 'shift ctrl cmd L', 'Rotate DELL P2715Q screen 0', ->
    hs.screen('DELL P2715Q')\rotate(0)

bind 'shift ctrl cmd P', 'Rotate DELL P2715Q screen 90', ->
    hs.screen('DELL P2715Q')\rotate(90)


-- A watcher must be exported to avoid Lua GC
export appWatcher = hs.application.watcher.new((appName, eventType, application) ->
    if (eventType == hs.application.watcher.activated)
        switch appName
            when 'Finder'
                -- Bring all Finder windows forward when one gets activated
                application\selectMenuItem({'Window', 'Bring All to Front'})
)\start()

export screenWatcher = hs.screen.watcher.new(->
    logger.d 'screen layout changed'
    if hs.screen('DELL P2715Q')
        logger.d 'DELL P2715Q connected'
        hs.application.launchOrFocus('SoundflowerBed')
        hs.audiodevice.findOutputByName('Soundflower (2ch)')\setDefaultOutputDevice()
    else
        logger.d 'DELL P2715Q disconnected'
        hs.audiodevice.findOutputByName('Built-in Output')\setDefaultOutputDevice()
        app = hs.application.get('SoundflowerBed')
        app\kill9() if app
)\start()

appBindings = {
    { 'alt 1', 'Sublime Text' }
    { 'alt 2', 'Atom' }
    { 'alt 3', 'MacVim' }
    { 'alt 4', 'Xcode' }
    { 'alt Q', 'QQ' }
    { 'alt W', 'WeChat' }
    { 'alt E', 'Wunderlist' }
    { 'alt R', 'Evernote' }
    { 'alt A', 'Calendar' }
    { 'alt S', 'Safari' }
    { 'alt T', 'Safari Technology Preview' }
    { 'alt Y', 'Typora' }
    { 'alt U', 'Ulysses' }
    { 'alt D', 'Day One' }
    { 'alt F', 'Finder' }
    { 'alt C', 'Google Chrome' }
    { 'alt B', 'MWeb' }
    { 'alt G', 'Telegram' }
    { 'alt H', 'Dash' }
    { 'alt J', 'IntelliJ IDEA CE' }
    { 'alt K', 'Skype' }
    { 'alt L', 'Microsoft Outlook' }
    { 'alt I', 'Dictionary' }
    { 'alt O', 'OmniFocus' }
    { 'alt P', 'Mailplane 3' }
    { 'alt N', 'Simplenote' }
    { 'alt M', 'Messages' }
}

hs.fnutils.each appBindings, (binding) ->
    bind binding[1], ->
        hs.application.launchOrFocus binding[2]
