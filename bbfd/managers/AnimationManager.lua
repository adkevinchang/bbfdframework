--region AnimationManager.lua
--Date
--此文件由[BabeLua]插件自动生成
--caosh
--龙骨动画管理  胜辉

local AnimationManager = class("AnimationManager");
AnimationManager.instance = nil;

function AnimationManager:getInstance()
   if not AnimationManager.instance then
      AnimationManager.instance = AnimationManager:create();
   end
   return AnimationManager.instance;
end

function AnimationManager:ctor()
    print("AnimationManager:ctor")

    self.dbFactory = db.DBCCFactory:getInstance()
end

--加载指定的龙骨动画
--@filePath 龙骨动画资源路径
function AnimationManager:loadDragonBonesFile(filePath)
    if not self.dbFactory then return end

    local name = string.gsub(filePath, "/", "-")
    if self.dbFactory:hasDragonBones(name) == false then
        self.dbFactory:loadDragonBonesData(filePath.."/skeleton.xml", name)
        self.dbFactory:loadTextureAtlas(filePath.."/texture.xml", name) 
    end
end

--加载多个龙骨动画
--@filePaths 龙骨动画资源路径，{"","",""}
function AnimationManager:loadDragonBonesFiles(filePaths)
    if not filePaths or #filePaths == 0 then return end

    if not self.dbFactory then return end

    for _, filePath in pairs(filePaths) do
        print("AnimationManager:loadDragonBonesFiles  path:" .. filePath .. "\n")

        local name = string.gsub(filePath, "/", "-")
        if self.dbFactory:hasDragonBones(name) == false then
            self.dbFactory:loadDragonBonesData(filePath.."/skeleton.xml", name)
            self.dbFactory:loadTextureAtlas(filePath.."/texture.xml", name) 
        end
    end
end

--添加龙骨动画
--@parent 父节点
--@animName 动画名字
--@position 动画位置，格式:{0,0}
--@visible 动画显示，默认true
--@scale 动画缩放，默认1
function AnimationManager:addAnimation(parent,animName,position,visible,scale)
    local x,y = 0,0
    if position then 
        x,y = position[1],position[2]
    end

    if visible == nil then 
        visible = true
    end

    if scale == nil then 
        scale = 1
    end

    local animation = self.dbFactory:buildArmatureNode(animName)
    if animation then
        animation:setPosition(cc.p(x,y))
        animation:setVisible(visible)
        animation:setScale(scale)
        parent:addChild(animation)
    end
    return animation
end

--移除龙骨动画
--@animation  动画实例
function AnimationManager:removeAnimation(animation)
    if animation then 
        animation:removeFromParentAndCleanup(true)
    end
end

--播放龙骨动画
--@animation 动画实例
--@animName 动画名字
function AnimationManager:playAnimation(animation,animName)
    if animation ~= nil then
       animation:getAnimation():gotoAndPlay(animName)
    end
end

--播放龙骨动画带回调函数
--@animation 动画实例
--@animStartName 初始动画名字
--@animEndName 动画播放完后动画名字，可以为nil,就不播放动画
--@callback 动画播放完回调函数
--@delayTime 延迟多少秒后执行回调函数
function AnimationManager:playAnimationCallBack(animation,animStartName,animEndName,callbcak,delayTime)
    animation:getAnimation():gotoAndPlay(animStartName)
    animation:registerAnimationEventHandler(function(event)
        if event.type == 7 then
            animation:unregisterAnimationEventHandler()
            delayTime = delayTime or 0.3

            local timer = require("bbfd.utils.Timer"):create()
            timer:runWithDelay(function()
                if animEndName then
                    animation:getAnimation():gotoAndPlay(animEndName)
                end

                if callbcak then 
                    callbcak()
                end
            end,delayTime)
        end
    end)
end

--[[
boneNode:龙骨名称
清除指定的龙骨文件缓存与图片资源缓存
kevin
]]
function AnimationManager:disposeDragonBones(boneNode,boneFile)
    if not self.dbFactory then return end
    if boneNode == nil and boneFile == nil then
        self.dbFactory:dispose(false)      --清空所有龙骨动画
        display.removeUnusedSpriteFrames()                  --清除所有不用纹理
        return
    end
    self.dbFactory:removeDragonBonesData(boneNode)
    self.dbFactory:removeTextureAtlas(boneNode)
    display.removeImage(boneFile.."/texture.png")
end

--endregion
return AnimationManager