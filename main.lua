package.path = package.path .. ";src/?.lua"

cc.FileUtils:getInstance():setPopupNotify(false)

cc.FileUtils:getInstance():addSearchPath(cc.FileUtils:getInstance():getWritablePath())
cc.FileUtils:getInstance():addSearchPath(cc.FileUtils:getInstance():getWritablePath().."downloadZipFile/src/")
cc.FileUtils:getInstance():addSearchPath(cc.FileUtils:getInstance():getWritablePath().."downloadZipFile/res/")
cc.FileUtils:getInstance():addSearchPath(cc.FileUtils:getInstance():getWritablePath().."downloadZipFile/res/brainsGame/")
cc.FileUtils:getInstance():addSearchPath(cc.FileUtils:getInstance():getWritablePath().."downloadZipFile/res/DragonBones/")
cc.FileUtils:getInstance():addSearchPath(cc.FileUtils:getInstance():getWritablePath().."downloadZipFile/res/Sound/")
cc.FileUtils:getInstance():addSearchPath(cc.FileUtils:getInstance():getWritablePath().."downloadZipFile/res/Sound/ChildrensSong/")
cc.FileUtils:getInstance():addSearchPath(cc.FileUtils:getInstance():getWritablePath().."downloadZipFile/res/noticeAsset/")
cc.FileUtils:getInstance():addSearchPath(cc.FileUtils:getInstance():getWritablePath().."downloadZipFile/netImage/")

cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")
cc.FileUtils:getInstance():addSearchPath("res/Sound/")
cc.FileUtils:getInstance():addSearchPath("res/Sound/ChildrensSong/")
cc.FileUtils:getInstance():addSearchPath("res/DragonBones/")
cc.FileUtils:getInstance():addSearchPath("res/brainsGame/")

cc.FileUtils:getInstance():addSearchPath("devGame/")
cc.FileUtils:getInstance():addSearchPath("devGame/res/")
cc.FileUtils:getInstance():addSearchPath("devGame/res/brainsGame/")
cc.FileUtils:getInstance():addSearchPath("devGame/res/DragonBones/")
cc.FileUtils:getInstance():addSearchPath("devGame/res/Sound/ChildrensSong/")

require "config"
require "cocos.init"
require "bbfd.GameConfig"

function updateDesignResolution()
    local director = CCDirector:sharedDirector()
    local glView = director:getOpenGLView()
    local frameSize = glView:getFrameSize()
    local visiSize = glView:getVisibleSize()
    local winSize = director:getWinSize()

    print("1111111111  frameSize.width:"..frameSize.width .."  frameSize.height:"..frameSize.height)
    print("2222222222  visiSize.width:"..visiSize.width .."  visiSize.height:"..visiSize.height)
    print("3333333333  winSize.width:"..winSize.width .."  winSize.height:"..winSize.height)

    local lsSize = cc.size(1280,800)
    local scalex = frameSize.width / lsSize.width
    local scaley = frameSize.height / lsSize.height

    local scale = 0
    if scalex > scaley then 
        scale = scalex/(frameSize.height/lsSize.height)
    else
        scale = scaley/(frameSize.width/lsSize.width)
    end

    print("hhhhhhhhhhhhhh  scalex:"..scalex .." scaley:"..scaley .." scale:"..scale)


    print("jjjjjjjjjjjj   "..lsSize.width*scale .. "    " ..lsSize.height*scale)
 -- glView:setDesignResolutionSize(1280, 720, kResolutionExactFit)

    display = display or {}
    display.scalex = scalex
    display.scaley = scaley
    display.newScale = scale
    display.newWidth = lsSize.width*scale
    display.newHeight = lsSize.height*scale
    display.offsetX = (lsSize.width*scale - winSize.width)/2
    display.offsetY = (lsSize.height*scale - winSize.height)/2

    dump(display.offsetX, "display.offsetX=")
    dump(display.offsetY, "display.offsetY=")

    glView:setDesignResolutionSize(lsSize.width*scale, lsSize.height*scale, cc.ResolutionPolicy.NO_BORDER)

   
end


local function main()
    --updateDesignResolution()
    require("app.MyApp"):create():run()
end

if RELEASE_PRINT then --打印开关
    print = release_print
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg) 
end

function babe_tostring(...)
    local num = select("#",...);
    local args = {...};
    local outs = {};
    for i = 1, num do
        if i > 1 then
            outs[#outs+1] = "\t";
        end
        outs[#outs+1] = tostring(args[i]);
    end
    return table.concat(outs);
end

local babe_print = print;
local babe_output = function(...)
    babe_print(...);

    if decoda_output ~= nil then
        local str = babe_tostring(...);
        decoda_output(str);
    end
end
print = babe_output;

