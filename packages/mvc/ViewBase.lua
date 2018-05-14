
--region ViewBase cocos
--ui 布局 根据不同的设备和分辨率做调整,不同状态的显示。
--device
local ViewBase = class("ViewBase", cc.Node)

--解析资源的节点
local function parseChildrenName(self,parent) 
    if parent ~= nil then
        for k,v in pairs(parent:getChildren()) do
            self[v:getName()] = v
            parseChildrenName(self,v)
        end
    end
end

function ViewBase:ctor(app, name, ...)
    self:enableNodeEvents()
    self.app_ = app
    self.name_ = name

    -- check CSB resource file
    local res = rawget(self.class, "RESOURCE_FILENAME")
    if res then
        self:createResourceNode(res)
    end

    local binding = rawget(self.class, "RESOURCE_BINDING")
    if res and binding then
        self:createResourceBinding(binding)
    end

    parseChildrenName(self,self.resourceNode_)

    if self.onCreate then self:onCreate(...) end

    autoScreen(self)

    --关闭按钮
    if self["closeBtn"] then
        self:addClickEventListener(self.closeBtn,handler(self,self.onClickClose))
    end
end

function ViewBase:getApp()
    return self.app_
end

function ViewBase:getName()
    return self.name_
end

function ViewBase:getResourceNode()
    return self.resourceNode_
end

function ViewBase:createResourceNode(resourceFilename)
    if self.resourceNode_ then
        self.resourceNode_:removeSelf()
        self.resourceNode_ = nil
    end
    self.resourceNode_ = cc.CSLoader:createNode(resourceFilename)
    assert(self.resourceNode_, string.format("ViewBase:createResourceNode() - load resouce node from file \"%s\" failed", resourceFilename))
    self:addChild(self.resourceNode_)
    --error("resource:"..resourceFilename);
end

function ViewBase:createResourceBinding(binding)
    assert(self.resourceNode_, "ViewBase:createResourceBinding() - not load resource node")
    for nodeName, nodeBinding in pairs(binding) do
        local node = self.resourceNode_:getChildByName(nodeName)
        if nodeBinding.varname then
            self[nodeBinding.varname] = node
        end
        for _, event in ipairs(nodeBinding.events or {}) do
            if event.event == "touch" then
                node:onTouch(handler(self, self[event.method]))
            end
        end
    end
end

function ViewBase:showWithScene(transition, time, more)
    self:setVisible(true)
    local scene = display.newScene(self.name_)
    scene:addChild(self)
    display.runScene(scene, transition, time, more)
    return self
end

--endregion

function ViewBase:goDispose()
    if self.destroy_ then 
        self.destroy_()
    end
end

--region ViewBase - yzyc gameApp 

function ViewBase:setDestroy(handler)
    self.destroy_ = handler
end

--获取操作管理类
function ViewBase:uiMgr()
    return bbfd.uiMgr;
end

--endregion

--动画管理类
function ViewBase:animMgr()
    return bbfd.animMgr
end

--声音管理类
function ViewBase:audioMgr()
    return bbfd.audioMgr
end

function ViewBase:onEnter()
    print("ViewBase:onEnter... ")

    self:playOpenAction()

    --添加键盘事件
    self:addKeybordEventListener()
end

--按钮点击事件(按下缩放效果)
--@btnNode 按钮节点
--@handler 回调函数
--@isPressedActionEnabled 是否开启缩放
--@zoomScale 缩放值
function ViewBase:addClickEventListener(btnNode, handler, isPressedActionEnabled, zoomScale)
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
function ViewBase:addKeybordEventListener()
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
function ViewBase:onKeyDown(key)
    --print("按下"..key)
end

-- 弹起某个键
function ViewBase:onKeyUp(key)
    --print("弹起"..key)
end

-- 安卓返回键
function ViewBase:onAndroidBack()
    --print("安卓返回键")
end

-- 遍历UI节点,返回指定名字的Node, 递归
function ViewBase:findNodeByName(root, name)
    if not root.getChildByName then return nil end

    local res = root:getChildByName(name)
    if res then
        return res
    else
        local children = root:getChildren()
        for _, ch in pairs(children) do
            res = self:findNodeByName(ch, name)
            if res then
                return res
            end
        end
    end
end

-- 打开UI动画
function ViewBase:playOpenAction()
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
function ViewBase:playCloseAction()
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
function ViewBase:close(isPlayCloseAction)
    if isPlayCloseAction == nil then isPlayCloseAction = true end
    
    if isPlayCloseAction then 
        self:playCloseAction()
    else
        self:removeSelf()
    end
end

-- 关闭按钮
function ViewBase:onClickClose(isPlayCloseAction)
    self:close(isPlayCloseAction)
end

return ViewBase
