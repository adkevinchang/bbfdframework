--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
--kevin
--布局处理  由于资源界面比较多，沿用之前的方式处理
local DisplayUtil = {}

function DisplayUtil:setActiveNodePosition(activeNode,pointType)
   local sceneOrigin  = cc.Director:getInstance():getVisibleOrigin() -- 从画布的某个点显示

    local positionX = activeNode:getPositionX()
    local positionY = activeNode:getPositionY()

    if pointType == bbfd.LAYOUT_TOP_LEFT then
       positionX  = positionX + sceneOrigin.x
       positionY  = positionY - sceneOrigin.y
    elseif pointType == bbfd.LAYOUT_TOP_MIDDLE then
        positionY  = positionY - sceneOrigin.y
    elseif pointType == bbfd.LAYOUT_TOP_RIGHT then
       positionX  = positionX - sceneOrigin.x
       positionY  = positionY - sceneOrigin.y
    elseif pointType == bbfd.LAYOUT_LEFT then
       positionX  = positionX + sceneOrigin.x
    elseif pointType == bbfd.LAYOUT_RIGHT then
       positionX  = positionX - sceneOrigin.x
    elseif pointType == bbfd.LAYOUT_BOTTOM_LEFT then
       positionX  = positionX + sceneOrigin.x
       positionY  = positionY + sceneOrigin.y
    elseif pointType == bbfd.LAYOUT_BOTTOM_MIDDLE then
        positionY  = positionY + sceneOrigin.y
    elseif pointType == bbfd.LAYOUT_BOTTOM_RIGHT then
       positionX  = positionX - sceneOrigin.x
       positionY  = positionY + sceneOrigin.y
    end
    activeNode:setPosition(positionX , positionY)
end

-- 自适应缩放   等比例缩放
function DisplayUtil:setActiveNodeScale(activeNode)
   if activeNode == nil then return end
   local sceneSize    = cc.Director:getInstance():getVisibleSize() -- 屏幕分辨率大小
   local sceneOrigin  = cc.Director:getInstance():getVisibleOrigin() -- 从画布的某个点显示
   local scaleValue = 1
    -- 如果origin.x不等于0，表示是左右是被裁过的，把activeNode的x位置设置到屏幕里的0的位置
    local scaleX = 1
    local scaleY = 1
    if sceneOrigin.x ~= 0 then
       scaleX = sceneSize.width/1280
    end

    -- y的设置理解同上，上下被裁过的
    if sceneOrigin.y ~= 0 then
       scaleY = sceneSize.height/800
    end

    scaleValue = math.min(scaleX,scaleY)

    activeNode:setScale(scaleValue)

    if activeNode:getName() == "Panel_ScaleX" then 
        activeNode:setScale(scaleX)
    elseif activeNode:getName() == "Panel_ScaleY" then
        activeNode:setScale(scaleY)
    else
        activeNode:setScale(scaleValue)
    end

    return scaleValue
end

--off
function DisplayUtil:layoutScreenOff( )
    -- body
    local offx , offy
    if display.sizeInPixels.width/display.sizeInPixels.height == display.width/display.height then
        offx = 0
        offy = 0
    elseif display.sizeInPixels.width/display.sizeInPixels.height < display.width/display.height then
        local width = display.sizeInPixels.width*display.height/display.sizeInPixels.height
        offx = (display.width - width)/2
        offy = 0
    elseif display.sizeInPixels.width/display.sizeInPixels.height > display.width/display.height then
        offx = 0
        local height = display.sizeInPixels.height*display.width/display.sizeInPixels.width
        offy = (display.height - height)/2
    end

    return offx,offy
end

--根据屏幕偏移，自动将Panel_Left,Panel_Right移动到对应位置
function DisplayUtil:autoScreen(viewbase)
    -- body
    local offx,offy = self:layoutScreenOff()

    if viewbase["Panel_Left"] ~= nil then
        local cHeight = viewbase["Panel_Left"]:getContentSize().height
        viewbase["Panel_Left"]:setPositionX(offx)
        viewbase["Panel_Left"]:setPositionY(display.height-cHeight-offy)
    end

    if viewbase["Panel_Left_Bottom"] ~= nil then
        viewbase["Panel_Left_Bottom"]:setPositionX(offx)
        viewbase["Panel_Left_Bottom"]:setPositionY(offy)
    end

    if viewbase["Panel_Left_Center"] ~= nil then
        viewbase["Panel_Left_Center"]:setPositionX(offx)
    end

    if viewbase["Panel_Top"] ~= nil then
        viewbase["Panel_Top"]:setPositionY(display.height-offy)
    end

    if viewbase["Panel_Right"] ~= nil then
        local cHeight = viewbase["Panel_Right"]:getContentSize().height
        viewbase["Panel_Right"]:setPositionX(display.width-offx)
        viewbase["Panel_Right"]:setPositionY(display.height-cHeight-offy)
    end

    if viewbase["Panel_Right_Bottom"] ~= nil then
        viewbase["Panel_Right_Bottom"]:setPositionX(display.width-offx)
        viewbase["Panel_Right_Bottom"]:setPositionY(offy)
    end

    if viewbase["Panel_Right_Top"] ~= nil then
        viewbase["Panel_Right_Top"]:setPositionX(-offx)
        viewbase["Panel_Right_Top"]:setPositionY(-offy)
    end

    if viewbase["Panel_Right_Center"] ~= nil then
        viewbase["Panel_Right_Center"]:setPositionX(display.width-offx)
    end

    if viewbase["Panel_Left_Top"] ~= nil then
        viewbase["Panel_Left_Top"]:setPositionX(offx)
        viewbase["Panel_Left_Top"]:setPositionY(-offy)
    end

    if viewbase["Panel_Bottom"] ~= nil then --锚点 0,0
        viewbase["Panel_Bottom"]:setPositionY(offy)
    end

    if viewbase["Panel_scale"] ~= nil then
        setActiveNodeScale(viewbase["Panel_scale"])
    end

    if self["Panel_Scale"] ~= nil then
        setActiveNodeScale(viewbase["Panel_Scale"])
    end

    if self["Panel_ScaleX"] ~= nil then
        setActiveNodeScale(viewbase["Panel_ScaleX"])
    end

    if self["Panel_ScaleY"] ~= nil then
        setActiveNodeScale(viewbase["Panel_ScaleY"])
    end
end

--缩放某节点到等比大小
function DisplayUtil:nodeEqualRatio(node,subscale)
   local scalenum = math.max(bbfd.display_scalex,bbfd.display_scaley)
   node:setScaleX(tonumber(node:getScaleX()+(node:getScaleX()-bbfd.display_scalex/node:getScaleX())))
   node:setScaleY(tonumber(node:getScaleY()+(node:getScaleY()-bbfd.display_scaley/node:getScaleY())))
   if subscale ~= nil then
        node:setScaleX(node:getScaleX()*subscale)
        node:setScaleY(node:getScaleY()*subscale)
   else
        node:setScaleX(node:getScaleX()*scalenum)
        node:setScaleY(node:getScaleY()*scalenum)
   end
   --node:setScaleX(bbfd.sub_scalex)
   --node:setScaleY(bbfd.sub_scaley)
end

--缩放某节点到等比大小 遍历所有的子集
function DisplayUtil:allChildEqualRatio(parentnode,subscale)
   for index = 1, #parentnode:getChildren() do  
        local nextNode = parentnode:getChildren()[index]  
        if "userdata" == type(nextNode) and nil ~= nextNode:getChildren() and 0 ~= nextNode:getChildrenCount() then  
            self:allChildEqualRatio(nextNode,subscale)  
        end
        self:nodeEqualRatio(nextNode,subscale)
    end 
end
--endregion

--region 显示对象的代码动画集合  overcall(sender)
--先大小大
--cc.DelayTime:create(0.25) 
--local move_ease_in = cc.EaseIn:create(createSimpleMoveBy(), 2.5)  
-- move_ease_out:reverse()  反向
--cc.RepeatForever:create(seq1) 循环

function DisplayUtil:clickEffectBSB(node,overcall)
    local scale1 = cc.ScaleBy:create(0.1, 1.3)
    local scale2 = scale1:reverse()  
    local scale3 = cc.ScaleTo:create(0.1,1) 
   --local ease_in_out  = cc.EaseElasticIn:create(scale1,3)
    if overcall ~= nil then
        local  finish = cc.CallFunc:create(overcall)
        local  action = cc.Sequence:create(scale1,scale2,scale3,finish)
        node:runAction(action)
    else
        local  action = cc.Sequence:create(scale1,scale2)
        node:runAction(action)
    end
end

--渐显位置冒泡，大小，消失
function DisplayUtil:popEffectBS(node,overcall)
    --printInfo("popeffectbs")
    node:setVisible(true)
    node:setOpacity(1)
    local  fadein = cc.FadeIn:create(0.2)
    local  move = cc.MoveBy:create(0.3, cc.p(0,node:getBoundingBox().height*1.5))
    local  scale1 = cc.ScaleBy:create(0.3,1.4)
    local  finish = cc.CallFunc:create(overcall)
    --local  opacity = cc.FadeOut:create(2)
    local  action = cc.Sequence:create(fadein,move,scale1,finish)
    node:runAction(action)
end


--endregion

return DisplayUtil