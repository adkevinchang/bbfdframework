--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
--kevin
--控制整个游戏的游戏节奏 动画缓存

local GameManager = class("GameManager");
GameManager.instance = nil;

function GameManager:getInstance()
   if not GameManager.instance then
      GameManager.instance = GameManager:create();
   end
   return GameManager.instance;
end

--[[
切换场景
control_class:模块控制
scene_asyncsize：异步文件加载个数
...:异步文件
]]
function GameManager:changeScene(control_class,scene_asyncsize,...)
    bbfd.uiMgr():getInstance():showLoadAction()
    if scene_asyncsize > 0 then
        local function loadCompScene()
            local control  = createGameControl(control_class)
        end;
        bbfd.downMgr():AsyncDownAssets(loadCompScene,scene_asyncsize,...)
        return
    end
    
    local control  = createGameControl(control_class)
end

--[[
设置当前应用对象
app:AppBase
]]
function GameManager:setCurrApp(app)
    assert(app, "GameManager:setCurrApp() - app is nil")
    self.app_ = app
end

function GameManager:getCurrApp()
   return self.app_
end

--endregion
return GameManager