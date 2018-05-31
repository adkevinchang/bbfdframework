--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local BaseComponent = class("BaseComponent",cc.load("mvc").ViewBase)
--对象池中方便使用

function BaseComponent:onCreate()
    if self["closeBtn"] then
        self:addClickEventListener(self.closeBtn,handler(self,self.onClickClose))
    end
    self:registerScriptHandler(function(eventType)
    if eventType == "enterTransitionFinish" then
        -- 场景被加载完成
        --self:onEnter()
        self:initLayout()
    end
    end)
end

--初始化小组件
function BaseComponent:initComponent(info)
    
end

--ui适配布局
function BaseScene:initLayout()

end

--清空组件但是不销毁组件
function BaseComponent:clearComponent()
   
end

function BaseComponent:onEnter()

    self:playOpenAction()

    --添加键盘事件
    self:addKeybordEventListener()
end

--function BaseComponent:onExit()

--end

--按钮点击事件(按下缩放效果)
--@btnNode 按钮节点
--@handler 回调函数
--@isPressedActionEnabled 是否开启缩放
--@zoomScale 缩放值
function BaseComponent:addClickEventListener(btnNode, handler, isPressedActionEnabled, zoomScale)
    if btnNode == nil then return end
    
    btnNode:addClickEventListener(handler)

    if isPressedActionEnabled == nil then 
        isPressedActionEnabled = true
    end

    btnNode:setPressedActionEnabled(isPressedActionEnabled)

    local zoomScale = zoomScale or -0.2--btnNode:getZoomScale()
    btnNode:setZoomScale(zoomScale)
end

-- 添加键盘事件
function BaseComponent:addKeybordEventListener()
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
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(KeyBoardListener, self)
end

-- 按下某个键
function BaseComponent:onKeyDown(key)
    --print("按下"..key)
end

-- 弹起某个键
function BaseComponent:onKeyUp(key)
    --print("弹起"..key)
end

-- 安卓返回键
function BaseComponent:onAndroidBack()
    --print("安卓返回键")
end

-- 打开UI动画
function BaseComponent:playOpenAction()
    local panelMark = self:findNodeByName(self,"panel_mark")
    local panelRoot = self:findNodeByName(self,"panel_root")
    if panelMark and panelRoot then
        panelRoot:setScale(0.6)
        panelMark:setTouchEnabled(false)

        local easeBackOut = cc.EaseBackOut:create(cc.ScaleTo:create(0.3,1))
        local callfunc = cc.CallFunc:create(function ()
                panelMark:setTouchEnabled(true)
            end)
        local action = cc.Sequence:create(easeBackOut, callfunc)
        panelRoot:runAction(action)
    end
end

-- 关闭UI动画
function BaseComponent:playCloseAction()
    local panelMark = self:findNodeByName(self,"panel_mark")
    local panelRoot = self:findNodeByName(self,"panel_root")
    if panelMark and panelRoot then
        local easeBackIn = cc.EaseBackIn:create(cc.ScaleTo:create(0.15,0.9))
        local callfunc = cc.CallFunc:create(function ()
                self:removeSelf()
            end)
        local action = cc.Sequence:create(easeBackIn, callfunc)
        panelRoot:runAction(action)
    end
end

-- 关闭界面(isPlayCloseAction为true时，播放完关闭动画后，再关闭界面)
function BaseComponent:close(isPlayCloseAction)
    if isPlayCloseAction == nil then isPlayCloseAction = true end
    
    if isPlayCloseAction then 
        self:playCloseAction()
    else
        self:removeSelf()
    end
end

-- 关闭按钮
function BaseComponent:onClickClose(isPlayCloseAction)
    self:close(isPlayCloseAction)
end

function BaseComponent:evtMgr()
    return bbfd.evtMgr
end

--动画管理类
function BaseComponent:animMgr()
    return bbfd.animMgr
end

--声音管理类
function BaseComponent:audioMgr()
    return bbfd.audioMgr
end


function BaseComponent:goDispose()
    BaseComponent.super:goDispose(self)
    if  self.controlTimer_ ~= nil then
        self.controlTimer_:killAll()
        self.controlTimer_ = nil
    end

end

--增加定时器
function BaseComponent:controlTimer()
    if  self.controlTimer_ == nil then
        self.controlTimer_ = require("bbfd.utils.Timer"):create()
    end
    return self.controlTimer_ 
end

--endregion
return BaseComponent