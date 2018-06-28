--region ControlBase.lua
--Date
--此文件由[BabeLua]插件自动生成
--kevin
--处理用户交互操作，已经数据交互逻辑，并管理ui逻辑

local ControlBase = class("ControlBase")
ControlBase.BbfdId = 0

--解析资源的节点
local function parseChildrenName(self,parent) 
    if parent ~= nil then
        for k,v in pairs(parent:getChildren()) do
            self[v:getName()] = v
            parseChildrenName(self,v)
        end
    end
end

function ControlBase:ctor(cview,cmodel)
    self.view_ = cview
    self.model_ = cmodel
    self.isFunMod_ = true
    ControlBase.BbfdId = ControlBase.BbfdId + 1
    self.bbfdId = "c"..ControlBase.BbfdId

    local binding = rawget(self.class, "RESOURCE_BINDING")
    if  self:getView() and binding then
        self:createViewBinding(binding)
        parseChildrenName(self,self:getView():getResourceNode())
    end

    if self.view_ or self.model_ then
        if self.onCreate then self:onCreate() end
    end
end

--初始化
function ControlBase:initCtor(cview,cmodel)
    self.view_ = cview
    self.model_ = cmodel
    local binding = rawget(self.class, "RESOURCE_BINDING")
    if  self:getView() and binding then
        self:createViewBinding(binding)
    end
    if self:getView() and self:getView():getResourceNode() then
        parseChildrenName(self,self:getView():getResourceNode())
    end

    if self.onCreate then self:onCreate() end
end

--初始化控制组件的view交互事件
function ControlBase:onCreate()
    self.viewonexithandler_ = handler(self,self.onExitHandle)
    self:evtMgr():AddListener(bbfd.EVENT_VIEW_ONEXIT,self.viewonexithandler_)

end

function ControlBase:createViewBinding(binding)
    assert(self:getView():getResourceNode(), "ControlBase:createViewBinding() - not load resource node")
    for nodeName, nodeBinding in pairs(binding) do
        local node = self:getView():getResourceNode():getChildByName(nodeName)
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

--初始化功能模块  子类必须重写此方法、
--类重构方法重写
--self.view_ = cview
-- self.model_ = cmodel

function ControlBase:initFunMod(viewname,modelvo,...)
   printInfo("ControlBase:initFunModa")
   local viewtmp = self:initModView(viewname,...)
   local modeltmp = self:initModModel(modelvo)
   --子类重构
   self:initCtor(viewtmp,modeltmp)

   printInfo("ControlBase:initFunModa")
   --XXX.super.initFunMod(self,viewname,modelvo)
end

function ControlBase:initModView(viewname,...)
    assert(self.modName_ , "ControlBase initModView() -  don't find "..self.modName_)
    local classpath = "app.views."..self.modName_.."."..self.modName_.."View"
    local viewtmp = require(classpath):create(nil,viewname,...)
    assert(viewtmp, "ControlBase initModView() -  don't find "..classpath)
    return viewtmp
end

function ControlBase:initModModel(modelvo)
    assert(self.modName_ , "ControlBase initModModel() -  don't find "..self.modName_)
    local classpath = "app.views."..self.modName_.."."..self.modName_.."Model"
    local modeltmp = require(classpath):create(modelvo)
    assert(modeltmp, "ControlBase initModModel() -  don't find "..classpath)
    return modeltmp
end

function ControlBase:showInScene(scene_)

end

--设置模块的包名
function ControlBase:setModName(modname)
   self.modName_ = modname
end

function ControlBase:getModName()
   return self.modName_
end

function ControlBase:onExitHandle(view)
printInfo("ControlBase:onExitHandle:"..self.bbfdId)
      if not tolua.isnull(self:getView()) and not tolua.isnull(view) then
        if self:getView() == view then
           self:goDispose()
        end
     end
end

--清除所有的内存和监听事件
--清除所有的常量
--view的移除操作不可以写在销毁方法中
function ControlBase:goDispose()
    if self.viewonexithandler_ then
        self:evtMgr():removeListener(bbfd.EVENT_VIEW_ONEXIT,self.viewonexithandler_)
    end
    
    if self.destroy_ then 
        self.destroy_()
    end

    --not tolua.isnull(self:getView())
    if not tolua.isnull(self:getView()) then
       self:getView():goDispose()
       --dump(self:getView():getParent())
       if not tolua.isnull(self:getView():getParent()) then
           if not self:getView():isExit() then
               self:getView():removeFromParent()
           end
       end
       self.view_ = nil
    end

    if self:getModel() ~= nil then
        if self:getModel().goDispose then
          self:getModel():goDispose()
       end
        self.model_ = nil
    end
    --self:uiMgr():clearCurrScene()

    --根据自己模块的需求使用垃圾回收
    if type(DEBUG) == "number" or DEBUG == 2 then
        --collectgarbage("collect")
    end
    printInfo("当前内存:"..collectgarbage("count"))
end

--region ViewBase - yzyc gameApp 
function ControlBase:setDestroy(handler)
    self.destroy_ = handler
end

--endregion

--region 属性管理

--引用的view和model对象尽量通过事件通讯，不要直接操作功能方法。
function ControlBase:getView()
    return self.view_
end

function ControlBase:getModel()
    return self.model_
end

function ControlBase:isFunMod()
    return  self.isFunMod_
end

--获取操作管理类
function ControlBase:uiMgr()
    return bbfd.uiMgr
end

function ControlBase:gameMgr()
    return bbfd.gameMgr
end


function ControlBase:evtMgr()
    return bbfd.evtMgr
end

function ControlBase:netMgr()
    return bbfd.netMgr
end

--对象池
function ControlBase:poolMgr()
   return bbfd.poolMgr;
end

--动画管理类
function ControlBase:animMgr()
    return bbfd.animMgr
end

--声音管理类
function ControlBase:audioMgr()
    return bbfd.audioMgr
end

--endregion

return ControlBase;
