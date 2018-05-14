--region UiManager.lua
--Date
--此文件由[BabeLua]插件自动生成
--UI界面管理，图层的管理

local UiManager = class("UiManager");
UiManager.instance = nil;

function UiManager:ctor()
    self.currScene = nil

    -- 当前场景打开Ui模块
    self.curSceneOpenUiList = {}
end

function UiManager:dtor()
    
end


function UiManager:getInstance()
   if not UiManager.instance then
      UiManager.instance = UiManager:create();
   end
   return UiManager.instance;
end

--初始化固定图层并添加到场景中
--0 背景层
--1 游戏层
--2 屏蔽层
--3 弹出层
function UiManager:initLayer(...)
    self.currLayers = nil
    if not self.currScene then
          error(" UiManager:initLayer - currScene is nil", 0)
    end
    if self.currScene then
        local params = {...}
        local c = #params
        self.currLayers = self.currLayers or {}
        local layer
        for i = 1, c do
          -- if i==1 then
           layer = bbfd.poolMgr:getFromPool("CCLayer")
          -- elseif i==2 then
          -- layer = display.newLayer({r = 255,g= 255,b=255,a=128})
          -- elseif i==3 then
          -- layer = display.newLayer({r = 255,g= 255,b=0,a=128})
          -- elseif i==4 then
          -- layer = display.newLayer({r = 0,g= 0,b=0,a=128})
          -- end
           --dump(layer:getScaleX(),"display_scalexa")
           --dump(layer:getScaleY(),"display_scaleya")
           layer:setName(params[i])
           layer:setScaleX(bbfd.display_scalex)
           layer:setScaleY(bbfd.display_scaley)
           --dump(layer:getScaleX(),"display_scalexb")
           --dump(layer:getScaleY(),"display_scaleyb")
           self.currLayers[i] = nil
           self.currLayers[i] = layer
           --layer:setPositionX(i*20)
           --layer:setPositionY(i*30)
           self.currScene:addChild(layer);
        end
    end
end

function UiManager:initScene(scene)
    if not scene then
          error(" UiManager:initScene - invalid parameters", 0)
    end
    if(self.currScene ~= nil and self.currScene._isuse~=nil)then
        self:getBgLayer():removeAllChildren()
        self:getGameLayer():removeAllChildren()
        self:getPanelLayer():removeAllChildren()
        self:getMaskLayer():removeAllChildren()
        self.currScene:removeAllChildren()
        bbfd.poolMgr:putInPool(self:getBgLayer(),"CCLayer")
        bbfd.poolMgr:putInPool(self:getGameLayer(),"CCLayer")
        bbfd.poolMgr:putInPool(self:getPanelLayer(),"CCLayer")
        bbfd.poolMgr:putInPool(self:getMaskLayer(),"CCLayer")
        bbfd.poolMgr:putInPool(self.currScene,"CCScene")
    end
    self.currScene = scene
    self:initLayer("mainbg","maingame","mainmask","mianpanel")
    self:initLoadAction()
    self:showLoadAction(false)
end

function UiManager:getBgLayer()
   if not self.currLayers then
          error(" UiManager:initLayer - not init", 0)
   end
   return self.currLayers[1] 
end

function UiManager:getGameLayer()
   if not self.currLayers then
          error(" UiManager:initLayer - not init", 0)
   end
   return self.currLayers[2] 
end

function UiManager:getMaskLayer()
   if not self.currLayers then
          error(" UiManager:initLayer - not init", 0)
   end
   return self.currLayers[3] 
end

function UiManager:getPanelLayer()
   if not self.currLayers then
          error(" UiManager:initLayer - not init", 0)
   end
   return self.currLayers[4] 
end

--初始化通用的加载动画和音效
function UiManager:initLoadAction()
   
   if self.loadAction then return end

   local factory = db.DBCCFactory:getInstance()
   factory:loadDragonBonesData("go001/skeleton.xml")
   factory:loadTextureAtlas("go001/texture.xml")
   self.loadAction = factory:buildArmatureNode("go001")
   --self:addChild(node)
   self.loadAction:setPosition(0,display.height)
   self.loadAction:retain()
   --self.loadAction:getAnimation():gotoAndPlay("start0")
   --self.soundId = ccexp.AudioEngine:play2d("loading.mp3", true)  --播放音效
   
end

--[[
是否显示动画
showed:true 
]]
function UiManager:showLoadAction(showed)
    if self.loadAction == nil then
        error(" UiManager:showLoading - no loadAction , Please UiManager:initScene(scene)", 0)
        return
    end
    if showed then
        self:getPanelLayer():addChild(self.loadAction)
        self.loadAction:setPosition(0,display.height)
        self.loadAction:getAnimation():gotoAndPlay("start0")
        self.soundId = ccexp.AudioEngine:play2d("loading.mp3", true)
    else
        if self.soundId ~= nil then
            self:getPanelLayer():removeChild(self.loadAction)
            ccexp.AudioEngine:stop(self.soundId)
        end
    end
end

function UiManager:clearCurrScene()
    if(self.currScene ~= nil and self.currScene._isuse~=nil)then
        self:getBgLayer():removeAllChildren()
        self:getGameLayer():removeAllChildren()
        self:getPanelLayer():removeAllChildren()
        self:getMaskLayer():removeAllChildren()
        self.currScene:removeAllChildren()
        bbfd.poolMgr:putInPool(self:getBgLayer(),"CCLayer")
        bbfd.poolMgr:putInPool(self:getGameLayer(),"CCLayer")
        bbfd.poolMgr:putInPool(self:getPanelLayer(),"CCLayer")
        bbfd.poolMgr:putInPool(self:getMaskLayer(),"CCLayer")
        bbfd.poolMgr:putInPool(self.currScene,"CCScene")
    end
    self.currScene = nil
end

--胜辉
--ui管理场景
function UiManager:getCurScene()
    return self.currScene
end

--创建模块
--@modName 模块名字
local function createModule(modName)
    local status, mod = xpcall(function()
        return require(modName)
    end, function(msg)
        if not string.find(msg, string.format("'%s' not found:", modName)) then
            print("load mod error: ", msg)
        end
    end)
    local t = type(mod)
    if status and (t == "table" or t == "userdata") then
        return mod:create()
    end
end

--显示场景模块
--@modName 模块名字
--@data 参数信息
--@transition 切换场景效果
--@time 效果时间
function UiManager:showScene(modName,data,transition,time)
    local mod = createModule(modName)
    local scene = display.newScene(modName)
    mod:showModuleToView(scene,data)

    self:initScene(scene)

    local transition = transition or "PAGETURN"
    local time = time or 0.5
    display.runScene(scene, transition, time)
end

--打开ui模块
--@modName 模块名字
--@data 参数信息
--@layer 指定添加到那一层，默认panelLayer
function UiManager:openUi(modName,data,layer)
    local layer = layer or self:getPanelLayer()
    local mod = createModule(modName)
    mod:showModuleToView(layer,data)

    self.curSceneOpenUiList[modName] = mod
end

--关闭ui模块
--@modName 模块名字
function UiManager:closeUi(modName)
    local mod = self.curSceneOpenUiList[modName]
    if not mode then return end

    mode:hideView()
end

--关闭所有ui模块
function UiManager:closeAllUi()
    for _,v in pairs(self.curSceneOpenUiList) do
        v:hideView()
    end
    self.curSceneOpenUiList = {}
end



return UiManager
--endregion
