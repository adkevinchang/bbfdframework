
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = true

--print
RELEASE_PRINT = false

-- 是否热更
HOT_UPDATE = true

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = false

-- for module display
CC_DESIGN_RESOLUTION = {
    width = 1280,
    height = 800,
    autoscale = "NO_BORDER",
    callback = function(framesize)
        local ratio = framesize.width / framesize.height
        if ratio <= 1.34 then
            -- iPad 768*1024(1536*2048) is 4:3 screen
            return {autoscale = "NO_BORDER"}    --SHOW_ALL
        end
    end
}

-- 版本信息及APPKEY的设置
GAME_SETTING = {
    channle = 41,       --1,5,6,8,9,12,13,16,17,19,22,23,24,25,29,30,31,37,40,41
    version = "3.3.0",
}
