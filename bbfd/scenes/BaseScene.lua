--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local BaseScene = class("BaseScene",cc.load("mvc").ViewBase);
--背景层
--游戏层
--屏蔽层
--弹出层

--进入场景
function BaseScene:goEnter()

end

function BaseScene:showWithScene(transition, time, more)
    self:setVisible(true)
    self:registerScriptHandler(function(eventType)
    if eventType == "enterTransitionFinish" then
        -- 场景被加载完成
        self:initLayout()
    end
    end)
end

function BaseScene:initLayout()

end

function BaseScene:changGameScene()

end

--退出场景
function BaseScene:goExit()

end

function BaseScene:initUi()
   
end

return BaseScene;
--endregion
