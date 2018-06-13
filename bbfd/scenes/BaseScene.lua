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
   
end

function BaseScene:onEnter()   
   
end  
  
  
function BaseScene:onEnterTransitionFinish()   
    self:initLayout()
end  
  
  
function BaseScene:onExit()   
    BaseScene.super.onExit(self)
end  
  
  
function BaseScene:onExitTransitionStart()   
  
end  
  
  
function BaseScene:cleanup()   
    
end 

return BaseScene;
--endregion
