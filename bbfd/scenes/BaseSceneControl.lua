--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
--kevin
local BaseSceneControl = class("BaseSceneControl",cc.load("mvc").ControlBase);

--进入场景
function BaseSceneControl:goEnter()
    --添加键盘事件
    self:addKeybordEventListener()
end

--退出场景
function BaseSceneControl:goExit()
   
end

-- 添加键盘事件
function BaseSceneControl:addKeybordEventListener()
    local function onPressed(code, event)
        local key = tostring(code)
        if code==cc.KeyCode.KEY_DPAD_LEFT or code==cc.KeyCode.KEY_KP_LEFT or code==cc.KeyCode.KEY_LEFT_ARROW then
            key = "LEFT"
        elseif code==cc.KeyCode.KEY_DPAD_RIGHT or code==cc.KeyCode.KEY_KP_RIGHT or code==cc.KeyCode.KEY_RIGHT_ARROW then
            key = "RIGHT"
        elseif code==cc.KeyCode.KEY_DPAD_UP or code==cc.KeyCode.KEY_KP_UP or code==cc.KeyCode.KEY_UP_ARROW then
            key = "UP"
        elseif code==cc.KeyCode.KEY_DPAD_DOWN or code==cc.KeyCode.KEY_KP_DOWN or code==cc.KeyCode.KEY_DOWN_ARROW then
            key = "DOWN"
        elseif code==cc.KeyCode.KEY_KP_HOME or code==cc.KeyCode.KEY_HOME then
            key = "HOME"
        elseif code==cc.KeyCode.KEY_BACKSPACE or code==cc.KeyCode.KEY_BACK then
            key = "BACK"
        elseif code==cc.KeyCode.KEY_DPAD_CENTER or code==cc.KeyCode.KEY_ENTER or code==cc.KeyCode.KEY_KP_ENTERthen then
            key = "ENTER"
        end
        self:onKeyDown(key)        
    end

    local function onReleased(code, event)
        local key = tostring(code)
        if code==cc.KeyCode.KEY_DPAD_LEFT or code==cc.KeyCode.KEY_KP_LEFT or code==cc.KeyCode.KEY_LEFT_ARROW then
            key = "LEFT"
        elseif code==cc.KeyCode.KEY_DPAD_RIGHT or code==cc.KeyCode.KEY_KP_RIGHT or code==cc.KeyCode.KEY_RIGHT_ARROW then
            key = "RIGHT"
        elseif code==cc.KeyCode.KEY_DPAD_UP or code==cc.KeyCode.KEY_KP_UP or code==cc.KeyCode.KEY_UP_ARROW then
            key = "UP"
        elseif code==cc.KeyCode.KEY_DPAD_DOWN or code==cc.KeyCode.KEY_KP_DOWN or code==cc.KeyCode.KEY_DOWN_ARROW then
            key = "DOWN"
        elseif code==cc.KeyCode.KEY_KP_HOME or code==cc.KeyCode.KEY_HOME then
            key = "HOME"
        elseif code==cc.KeyCode.KEY_BACKSPACE or code==cc.KeyCode.KEY_BACK then
            key = "BACK"
            self:onAndroidBack()
        elseif code==cc.KeyCode.KEY_DPAD_CENTER or code==cc.KeyCode.KEY_ENTER or code==cc.KeyCode.KEY_KP_ENTERthen then
            key = "ENTER"
        end
        self:onKeyUp(key)
    end

    local KeyBoardListener = cc.EventListenerKeyboard:create()
    KeyBoardListener:registerScriptHandler(onPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
    KeyBoardListener:registerScriptHandler(onReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)
    self:getView():getEventDispatcher():addEventListenerWithSceneGraphPriority(KeyBoardListener, self:getView())
end

-- 按下某个键
function BaseSceneControl:onKeyDown(key)
    --print("按下"..key)
end

-- 弹起某个键
function BaseSceneControl:onKeyUp(key)
    --print("弹起"..key)
end

-- 安卓返回键
function BaseSceneControl:onAndroidBack()
    --print("安卓返回键")
end


function BaseSceneControl:goDispose()
    if  self.controlTimer_ then
        self.controlTimer_:killAll()
    end
    self.controlTimer_ = nil 
    BaseSceneControl.super.goDispose(self)
end

--增加定时器
function BaseSceneControl:controlTimer()
    if  self.controlTimer_ == nil then
        self.controlTimer_ = require("bbfd.utils.Timer"):create()
    end
    return self.controlTimer_ 
end

return BaseSceneControl
--endregion
