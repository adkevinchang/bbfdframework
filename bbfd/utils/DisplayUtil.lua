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
        self:setActiveNodeScale(viewbase["Panel_scale"])
    end

    if self["Panel_Scale"] ~= nil then
        self:setActiveNodeScale(viewbase["Panel_Scale"])
    end

    if self["Panel_ScaleX"] ~= nil then
        self:setActiveNodeScale(viewbase["Panel_ScaleX"])
    end

    if self["Panel_ScaleY"] ~= nil then
        self:setActiveNodeScale(viewbase["Panel_ScaleY"])
    end
end


--相同的缩放比例
--tnode 目标对象
--cnode 复制对象
function DisplayUtil:nodeSomeScale(tnode,cnode)
    if not tolua.isnull(tnode) == nil then return end
    if not tolua.isnull(cnode) == nil then return end
    cnode:setScaleX(tnode:getScaleX())
    cnode:setScaleY(tnode:getScaleY())
end

--缩放某节点到等比大小
function DisplayUtil:nodeEqualRatio(node,subscale)
   if node == nil then return end
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
   if parentnode == nil then return end
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
    if node == nil then return end
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
    if node == nil then return end
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

--快速变大还原
function DisplayUtil:toBigBackEffect(node,overcall)
    if tolua.isnull(node) then return end
    local currscale = node:getScale();
    node:setVisible(true)
    node:setOpacity(1)
    local  fadein = cc.FadeIn:create(0.4)
    local  scale1 = cc.ScaleBy:create(0.2,1.3)
    local  scale2 = scale1:reverse()
    local  delayact = cc.DelayTime:create(3)

    if overcall ~= nil then
         local  finish = cc.CallFunc:create(overcall)
         local  action = cc.Sequence:create(fadein,scale1,scale2,delayact,finish)
         node:runAction(action)
    else
         local  action = cc.Sequence:create(fadein,scale1,scale2,delayact)
         node:runAction(action)
    end
     --dump(node)
end

--由大到小
function DisplayUtil:bigToSmallEffect(node,overcall)
    if node == nil then return end
    --printInfo("DisplayUtil:bigToSmallEffect")
    local currscale = node:getScale();
    node:setVisible(true)
    node:setOpacity(1)
    node:setScale(node:getScale()*5)
    local  fadein = cc.FadeIn:create(0.6)
    local  scale1 = cc.ScaleTo:create(0.6,currscale)

    if overcall ~= nil then
         local  finish = cc.CallFunc:create(overcall)
         local  action = cc.Sequence:create(fadein,scale1,finish)
         node:runAction(action)
    else
         local  action = cc.Sequence:create(fadein,scale1)
         node:runAction(action)
    end
     --dump(node)
end

--解析资源的节点
function DisplayUtil:parseChildrenName(mself,parent) 
    if parent ~= nil then
        for k,v in pairs(parent:getChildren()) do
            mself[v:getName()] = v
            self:parseChildrenName(mself,v)
        end
    end
end

--数字翻滚
function DisplayUtil:showNumEffect(node,nums,overcall)
   if node == nil then return end
   local delayact = cc.DelayTime:create(0.1)
   local currnum = 0
   local function setNumStr()
      -- printInfo("currnum:"..currnum)
       currnum = currnum + 1
       if currnum < nums then
            node:setString(tostring(currnum))
       else
            node:setString(tostring(nums))
            node:stopAllActions()
            if overcall ~= nil then
                overcall()
            end
       end
   end
   
   local call = cc.CallFunc:create(setNumStr)
   local seq2 = cc.Sequence:create(delayact,call)
   local seq3 = cc.RepeatForever:create(seq2)
   node:runAction(seq3)
end

function DisplayUtil:translationEffect(node,px,py,overcall)
    if node == nil then return end
    local movebyact = cc.MoveBy:create(0.5, cc.p(px,py))
    if overcall ~= nil then
        local seq1 = cc.Sequence:create(movebyact,overcall)
        node:runAction(seq1)
    else
        node:runAction(movebyact)
    end
end

--移动到指定目标
function DisplayUtil:showMoveTo(node,time,position,overcall)
   if tolua.isnull(node) then return end
   local seq = cc.Sequence:create(cc.MoveTo:create(time,position),
                                    cc.CallFunc:create(function()
                                        if overcall ~= nil then
                                            overcall()
                                        end
                                    end)
                                  )
    node:runAction(seq)
end

--移动指定目标一段距离
function DisplayUtil:showMoveBy(node,time,position,overcall)
   if tolua.isnull(node) then return end
   local seq = cc.Sequence:create(cc.MoveBy:create(time,position),
                                    cc.CallFunc:create(function()
                                        if overcall ~= nil then
                                            overcall()
                                        end
                                    end)
                                  )
    node:runAction(seq)
end

--移动到指定目标
function DisplayUtil:showScaleTo(node,time,scaleval,overcall)
   if tolua.isnull(node) then return end
   local easeBackOut = cc.EaseBackOut:create(cc.ScaleTo:create(time,scaleval))
   local seq = cc.Sequence:create(easeBackOut,
                                    cc.CallFunc:create(function()
                                        if overcall ~= nil then
                                            overcall()
                                        end
                                    end)
                                  )
    node:runAction(seq)
end


--移动效果到指定目标
function DisplayUtil:showEffMoveTo(node,time,position,overcall)
   if tolua.isnull(node) then return end
   local easeBackOut = cc.EaseBackOut:create(cc.MoveTo:create(time,position))
   local seq = cc.Sequence:create(easeBackOut,
                                    cc.CallFunc:create(function()
                                        if overcall ~= nil then
                                            overcall()
                                        end
                                    end)
                                  )
    node:runAction(seq)
end

--[[

延迟
    local delay =cc.DelayTime:create(0.01)
        table.insert(taction,delay)
--扩大
        local scale = cc.ScaleTo:create(0.2,2)
        local scale2 = cc.ScaleTo:create(0.2,1)
           table.insert(taction,scale)
           table.insert(taction,scale2)
-- 数值改变
        _endNum =10000
        math.randomseed(3000)
        _dis = math.random(5000,10000)
        print(_dis)
    local rtime = (_endNum-_beginNum)/_dis
        print(rtime)
    function chagenum()
        if (_beginNum <  _endNum) then
           _beginNum= _beginNum +_dis
            txt:setString(_beginNum)
        elseif (_beginNum ==  _endNum) then
            txt:setString(  _endNum)
        end
    end
    local seq = cc.Sequence:create(delay,cc.CallFunc:create(chagenum))]]
--endregion

return DisplayUtil