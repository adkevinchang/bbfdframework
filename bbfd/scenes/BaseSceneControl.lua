--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
--kevin
local BaseSceneControl = class("BaseSceneControl",cc.load("mvc").ControlBase);

--进入场景
function BaseSceneControl:goEnter()

end

--退出场景
function BaseSceneControl:goExit()

end


function BaseSceneControl:goDispose()
    BaseSceneControl.super:goDispose()
    if  self.controlTimer_ ~= nil then
        self.controlTimer_:killAll()
        self.controlTimer_ = nil
    end

end

--增加定时器
function BaseSceneControl:controlTimer(args)
    if  self.controlTimer_ == nil then
        self.controlTimer_ = require("bbfd.utils.Timer"):create()
    end
    return self.controlTimer_ 
end

return BaseSceneControl
--endregion
