--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local BaseScene = class("BaseScene",cc.load("mvc").ViewBase)
--背景层
--游戏层
--屏蔽层
--弹出层

function BaseScene:showWithScene(transition, time, more)
    self:setVisible(true)
    self.isInitScene_ = false
   --[[ self:registerScriptHandler(function(eventType)
    if eventType == "enterTransitionFinish" then
        self:initLayout()
    end
    end)]]
end

function BaseScene:initLayout()

end

function BaseScene:changGameScene()

end

function BaseScene:initUi()
   self.isInitScene_ = true

end

function BaseScene:onEnter()   
   printInfo("BaseScene:onEnter:"..self.bbfdId)
end  
  
  
function BaseScene:onEnterTransitionFinish()  
    --printInfo("BaseScene:onEnterTransitionFinish"..self.bbfdId) 
    self:evtMgr():Brocast(bbfd.EVENT_VIEW_ONENTER,self)
    self:initLayout()
end  
  
  
function BaseScene:onExit()   
    BaseScene.super.onExit(self)
    printInfo("BaseScene:onExit"..self.bbfdId)
end  
  
function BaseScene:isInitScene()
    if self.isInitScene_ == nil then
       self.isInitScene_ = false
    end
    return self.isInitScene_
end

function BaseScene:onExitTransitionStart()   
    printInfo("BaseScene:onExitTransitionStart"..self.bbfdId)
end  
  
  
function BaseScene:cleanup()   
    printInfo("BaseScene:cleanup"..self.bbfdId)
end 

return BaseScene;
--endregion
