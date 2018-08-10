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
    if not tolua.isnull(self.currScene) then
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
          -- printInfo("currLayers:"..i)
           self.currLayers[i]:removeAllChildren()
           if layer:getParent() ~= self.currScene then
             self.currScene:addChild(layer);
           end

        end
    end
end

function UiManager:initScene(scene)
    if tolua.isnull(scene) then
          error(" UiManager:initScene - invalid parameters", 0)
    end
    if self.currScene == scene then return end
    
     --旧场景和图层处理
    if not tolua.isnull(self.currScene) then
       self.currScene:removeAllChildren()
       if self.currScene._isuse ~= nil then --是否是缓存池场景
            if self.currScene._isuse == 1 then --已经在使用的场景
                bbfd.poolMgr:putInPool(self.currScene,"CCScene")
            end
       end
       self.currScene = nil
    end
    
    if self.currLayers ~=nil then
        if(not tolua.isnull(self:getBgLayer()))then
	        self:getBgLayer():removeAllChildren()
            self:getBgLayer():removeFromParent()
            if self:getBgLayer()._isuse == 1 then --已经在使用的场景
                bbfd.poolMgr:putInPool(self:getBgLayer(),"CCLayer")
            end
	    end
	    if(not tolua.isnull(self:getGameLayer()))then
	       self:getGameLayer():removeAllChildren()
           self:getGameLayer():removeFromParent()
           if self:getGameLayer()._isuse == 1 then --已经在使用的场景
	            bbfd.poolMgr:putInPool(self:getGameLayer(),"CCLayer")
           end
	    end
	    if(not tolua.isnull(self:getPanelLayer()))then
	       self:getPanelLayer():removeAllChildren()
           self:getPanelLayer():removeFromParent()
           if self:getPanelLayer()._isuse == 1 then --已经在使用的场景
	           bbfd.poolMgr:putInPool(self:getPanelLayer(),"CCLayer")
           end
	    end
	    if(not tolua.isnull(self:getMaskLayer()))then
		    self:getMaskLayer():removeAllChildren()
            self:getMaskLayer():removeFromParent()
            if self:getMaskLayer()._isuse == 1 then --已经在使用的场景
                bbfd.poolMgr:putInPool(self:getMaskLayer(),"CCLayer")
            end
	    end
    end
    self.currScene = scene
    self:initLayer("mainbg","maingame","mainmask","mianpanel")
end

--初始化过渡动画场景
function UiManager:initTraScene(scene,time)
   if tolua.isnull(scene) then
          error(" UiManager:initScene - invalid parameters", 0)
    end
   if self.currScene == scene then return end
   if time == nil then
      self:initScene(scene)
      return 
   end
   --旧场景和图层处理
   if not tolua.isnull(self.currScene) then
       self.currSceneTemp = self.currScene
    end
    
    if self.currLayers ~=nil then
        if(not tolua.isnull(self:getBgLayer()))then
            self.bgLayerTemp = self:getBgLayer()
	    end
	    if(not tolua.isnull(self:getGameLayer()))then
	       self.gameLayerTemp = self:getGameLayer()
	    end
	    if(not tolua.isnull(self:getPanelLayer()))then
	       self.panelLayerTemp = self:getPanelLayer()
	    end
	    if(not tolua.isnull(self:getMaskLayer()))then
		    self.maskLayerTemp = self:getMaskLayer()
	    end
   end

   self:controlTimer():runWithDelay(function ()
       if not tolua.isnull(self.currSceneTemp) then
           self.currSceneTemp:removeAllChildren()
           if self.currSceneTemp._isuse ~= nil then --是否是缓存池场景
                if self.currSceneTemp._isuse == 1 then --已经在使用的场景
                    bbfd.poolMgr:putInPool(self.currSceneTemp,"CCScene")
                end
           end
           self.currSceneTemp = nil
       end
    
       if(not tolua.isnull(self.bgLayerTemp))then
                self.bgLayerTemp:removeAllChildren()
                self.bgLayerTemp:removeFromParent()
                if self.bgLayerTemp._isuse == 1 then --已经在使用的图层
                    bbfd.poolMgr:putInPool(self.bgLayerTemp,"CCLayer")
                end
                self.bgLayerTemp = nil
	        end
	        if(not tolua.isnull(self.gameLayerTemp))then
	            self.gameLayerTemp:removeAllChildren()
                self.gameLayerTemp:removeFromParent()
                if self.gameLayerTemp._isuse == 1 then --已经在使用的图层
                    bbfd.poolMgr:putInPool(self.gameLayerTemp,"CCLayer")
                end
                self.gameLayerTemp = nil
	        end
	        if(not tolua.isnull(self.panelLayerTemp))then
	            self.panelLayerTemp:removeAllChildren()
                self.panelLayerTemp:removeFromParent()
                if self.panelLayerTemp._isuse == 1 then --已经在使用的图层
                    bbfd.poolMgr:putInPool(self.panelLayerTemp,"CCLayer")
                end
                self.panelLayerTemp = nil
	        end
	        if(not tolua.isnull(self.maskLayerTemp))then
		        self.maskLayerTemp:removeAllChildren()
                self.maskLayerTemp:removeFromParent()
                if self.maskLayerTemp._isuse == 1 then --已经在使用的图层
                    bbfd.poolMgr:putInPool(self.maskLayerTemp,"CCLayer")
                end
                self.maskLayerTemp = nil
	        end
   end,time)

   self.currScene = scene
   self:initLayer("mainbg","maingame","mainmask","mianpanel")
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

--[[
是否显示动画
showed:true 
]]
function UiManager:showLoadAction(showed)
    if showed then
        printInfo("UiManager:showLoadAction addChild1")

		bbfd.animMgr:loadDragonBonesFile("go001")

		self.loadAction = bbfd.animMgr:addAnimation(self:getPanelLayer(),"go001",{0,display.height})
		bbfd.animMgr:playAnimation(self.loadAction,"start0")

		bbfd.audioMgr:stopAllEffect()
		self.soundId = bbfd.audioMgr:playEffect("loading.mp3", true)
    else
        printInfo("UiManager:showLoadAction addChild2")

        if self.soundId ~= nil then
			bbfd.audioMgr:stopEffect(self.soundId)
        end
	
		if self.loadAction then 
			bbfd.animMgr:disposeDragonBones("go001","go001")
			self.loadAction:removeFromParent()
		end
    end
end

function UiManager:clearCurrScene()
    if(self.currScene ~= nil and self.currScene._isuse~=nil)then
        self.currScene:removeAllChildren()
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

--增加定时器
function UiManager:controlTimer()
    if  self.controlTimer_ == nil then
        self.controlTimer_ = require("bbfd.utils.Timer"):create()
    end
    return self.controlTimer_ 
end

return UiManager
--endregion
