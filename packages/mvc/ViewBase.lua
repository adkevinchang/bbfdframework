
--region ViewBase cocos
--ui 布局 根据不同的设备和分辨率做调整,不同状态的显示。
--device
-- bbfdid对象唯一id
local ViewBase = class("ViewBase", cc.Node)
ViewBase.BbfdId = 0

--解析资源的节点
local function parseChildrenName(self,parent) 
    if parent ~= nil then
        for k,v in pairs(parent:getChildren()) do
            self[v:getName()] = v
            parseChildrenName(self,v)
        end
    end
end

function ViewBase:ctor(app,name,...)
    --printInfo("ViewBase:ctor")
    self:enableNodeEvents()
    self.app_ = app
    self.name_ = name
    self.isExit_ = false
    ViewBase.BbfdId = ViewBase.BbfdId + 1
    self.bbfdId = "v"..ViewBase.BbfdId
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

    DisplayUtil:autoScreen(self)
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

function ViewBase:onExit()  
   self.isExit_ = true
   printInfo("ViewBase:onExit:"..self.bbfdId)
   self:evtMgr():Brocast(bbfd.EVENT_VIEW_ONEXIT,self)
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
--region ViewBase - yzyc gameApp 

function ViewBase:isExit()
   return  self.isExit_
end

--获取操作管理类
function ViewBase:uiMgr()
   return bbfd.uiMgr;
end

function ViewBase:poolMgr()
   return bbfd.poolMgr;
end

function ViewBase:evtMgr()
    return bbfd.evtMgr
end
--endregion

return ViewBase
