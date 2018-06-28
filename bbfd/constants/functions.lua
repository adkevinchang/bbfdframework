--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
--全局方法

--生成功能模块控制--
function createGameControl(ctrlclassstr,viewname,modelvo)
    local control = require(ctrlclassstr):create()
    --print(ctrlclassstr)
    assert(control, "functions createGameControl() -  don't find "..ctrlclassstr)
    control:initFunMod(viewname,modelvo)
    return control
end

--启动功能模块--
--[[
modename:功能模块的文件夹名
]]
function StartupGameControl(modename,viewname,modelvo,...)
    local control = require("app.views."..modename.."."..modename.."Control"):create()
    --print(ctrlclassstr)
    assert(control, "functions StartupGameControl() -  don't find "..modename)
    control:setModName(modename)
    control:initFunMod(viewname,modelvo,...)
    return control
end

function createTimer()
    local currtime = require("bbfd.utils.Timer"):create()
    return currtime
end

--重新载入lua文件
function reload(file)
    package.loaded[file] = nil
    require(file)
end

--endregion

