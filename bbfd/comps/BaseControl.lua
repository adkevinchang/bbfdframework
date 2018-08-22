--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local BaseControl = class("BaseControl",cc.load("mvc").ControlBase)

function BaseControl:onCreate()
end

function BaseControl:goDispose()
    BaseControl.super.goDispose(self)
    if  self.controlTimer_ ~= nil then
        self.controlTimer_:killAll()
        self.controlTimer_ = nil
    end

end

--增加定时器
function BaseControl:controlTimer()
    if  self.controlTimer_ == nil then
        self.controlTimer_ = require("bbfd.utils.Timer"):create()
    end
    return self.controlTimer_ 
end

--endregion
return BaseControl

--endregion
