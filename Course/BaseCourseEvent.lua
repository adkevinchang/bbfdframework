--region *.lua
--Date
--[[
基础事件指令类主要包括：（根据不同事件指令类型可扩展）
--bbfd.COURSE_EVENT_ORDER.SET_FILPPED
--bbfd.COURSE_EVENT_ORDER.SET_SCALE
--bbfd.COURSE_EVENT_ORDER.TIME
--bbfd.COURSE_EVENT_ORDER.MOVE_TO
--bbfd.COURSE_EVENT_ORDER.SCALE_TO
--bbfd.COURSE_EVENT_ORDER.SET_POSITION
--bbfd.COURSE_EVENT_ORDER.SET_OPACITY
]]
--kevin
local BaseCourseEvent = class("BaseCourseEvent")
--{type = "Time",time = 24 , interactName = {"start0","start0","start1","start2"} ,music = "qingxu0105_1_1.mp3"},
BaseCourseEvent.eventnum = 0

function BaseCourseEvent:ctor(vo,...)
    self.vo_ = vo or {}
    self.isFinish_ = false
    BaseCourseEvent.eventnum = BaseCourseEvent.eventnum + 1
    self.eventid_ = BaseCourseEvent.eventnum
    if self.onCreate then self:onCreate(...) end
end

--dbobj交互对象
--couseCtrl 当前课程控制对象
--dbnodea 
------------------------------------------------------------------------------------初始化指令类参数
function BaseCourseEvent:onCreate(couseCtrl,dbobj,dbnodea)
   self.dbInteract = dbobj
   self.dbnode = dbnodea
   self.currCouseCtrl = couseCtrl
   self:onInit()
end

function BaseCourseEvent:onInit()
    
end

-------------------------------------------------------------------------------------具体执行动作处理
function BaseCourseEvent:execute(...)
     printInfo("BaseCourseEvent:execute")
     if self:getVo().type == bbfd.COURSE_EVENT_ORDER.SET_FILPPED then
         if self:getVo().XorY == true then
                local oldScale = math.abs(self.currCouseCtrl[self:getVo().object]:getScaleX()) 
    		    if self:getVo().filpped == true then
    			    self.currCouseCtrl[self:getVo().object]:setScaleX(-oldScale)
    		    else
    			    self.currCouseCtrl[self:getVo().object]:setScaleX(oldScale)
    		    end
    	    else
                local oldScale = math.abs(self.currCouseCtrl[self:getVo().object]:getScaleY()) 
    		    if event.filpped == true then
    			    self.currCouseCtrl[self:getVo().object]:setScaleY(-oldScale)
    		    else
    			    self.currCouseCtrl[self:getVo().object]:setScaleY(oldScale)
    		    end
    	    end
        self:executeFinish()
        self:goDispose()
    elseif self:getVo().type == bbfd.COURSE_EVENT_ORDER.SET_SCALE then
        local scale = self:getVo().scale
        if not tolua.isnull(self.currCouseCtrl[self:getVo().object]) then
            self.currCouseCtrl[self:getVo().object]:setScale(scale)
        end
        self:executeFinish()
        self:goDispose()
    elseif self:getVo().type == bbfd.COURSE_EVENT_ORDER.SET_OPACITY then
        local opacity = self:getVo().opacity
        if not tolua.isnull(self.currCouseCtrl[self:getVo().object]) then
            self.currCouseCtrl[self:getVo().object]:setOpacity(opacity)
        end
        self:executeFinish()
        self:goDispose()
    elseif self:getVo().type == bbfd.COURSE_EVENT_ORDER.SET_VISIBLE then
        local targetObj = self.currCouseCtrl[self:getVo().object]
        targetObj:setVisible(self:getVo().visible)
        self:executeFinish()
        self:goDispose()
    elseif self:getVo().type == bbfd.COURSE_EVENT_ORDER.SCALE_TO then
        local targetObj = self.currCouseCtrl[self:getVo().object]
        dump(targetObj)
        local seq = cc.Sequence:create(cc.ScaleTo:create(self:getVo().time,self:getVo().scale),
                                    cc.CallFunc:create(function()
                                        if self:getVo()~= nil and self:getVo().fastNext ~= true then
                                            self:executeFinish()
                                        end
                                    end)
                                     )
        targetObj:runAction(seq)
        if self:getVo()~= nil and self:getVo().fastNext == true then
            self:executeFinish()
        end
        self:goDispose()
    elseif self:getVo().type == bbfd.COURSE_EVENT_ORDER.SET_POSITION then
        self.currCouseCtrl[self:getVo().object]:setPosition(self:getVo().position.x,self:getVo().position.y)--dbnode5
        --dump(self.currCouseCtrl[self:getVo().object])
        self:executeFinish()
        self:goDispose()
    elseif  self:getVo().type == bbfd.COURSE_EVENT_ORDER.TIME then
        printInfo("------------------------------------------------bbfd.COURSE_EVENT_ORDER.TIME")
        if self:getVo().interactName ~= nil then
            local eventAniName = self:getVo().interactName
            for i=1,#eventAniName do
                if eventAniName[i] ~= nil and eventAniName[i] ~= "" and self.dbInteract[i] ~=nil then
                    self.dbInteract[i]:setVisible(true)
                    self.dbInteract[i]:getAnimation():clear()
                    self.dbInteract[i]:getAnimation():gotoAndPlay(eventAniName[i])
                    printInfo("eventAniName:"..eventAniName[i])
                end
            end
        end
        --dump(self:getVo().aniName)
        --通用逻辑实现
        if self:getVo().aniName ~= nil then
            local eventAniName = {}
            if type(self:getVo().aniName) == "string" then
                table.insert(eventAniName,self:getVo().aniName)
            else
                eventAniName = self:getVo().aniName
            end
            --printInfo("---------------timea")
           -- dump(eventAniName)
            for i=1,#eventAniName do
                if eventAniName[i] ~= nil and eventAniName[i] ~= "" and self.dbnode[i] ~=nil and self.dbnode[i].animationName ~= eventAniName[i] then
                    self.dbnode[i]:setVisible(true)
                    self.dbnode[i].animationName = eventAniName[i]
                    self.dbnode[i]:getAnimation():clear()
                    local animationName = eventAniName[i]
                    --printInfo("---------------timeb:"..animationName)
                    --哆哆和哆美动作镜像
                    local scale = math.abs(self.dbnode[i]:getScaleX())
                    local armatureName = self.dbnode[i].armatureName
                    if armatureName == "duoduo" then
                        if self.dbnode[i].animationScaleX == true then
                            self.dbnode[i]:setScaleX(scale)
                            self.dbnode[i].animationScaleX = false
                        end

                        if animationName == "start3" then
                            animationName = "start1"
                            self.dbnode[i]:setScaleX(-scale)
                            self.dbnode[i].animationScaleX = true
                        elseif animationName == "start7" then
                            animationName = "start5"
                            self.dbnode[i]:setScaleX(-scale)
                            self.dbnode[i].animationScaleX = true
                        elseif animationName == "start11" then
                            animationName = "start9"
                            self.dbnode[i]:setScaleX(-scale)
                            self.dbnode[i].animationScaleX = true
                        elseif animationName == "start17" then
                            animationName = "start15"
                            self.dbnode[i]:setScaleX(-scale)
                            self.dbnode[i].animationScaleX = true
                        elseif animationName == "start21" then
                            animationName = "start19"
                            self.dbnode[i]:setScaleX(-scale)
                            self.dbnode[i].animationScaleX = true
                        elseif animationName == "start13" then
                            animationName = "start12"
                            self.dbnode[i]:setScaleX(-scale)
                            self.dbnode[i].animationScaleX = true
                        elseif animationName == "start23" then
                            animationName = "start22"
                            self.dbnode[i]:setScaleX(-scale)
                            self.dbnode[i].animationScaleX = true
                        elseif animationName == "start25" then
                            animationName = "start24"
                            self.dbnode[i]:setScaleX(-scale)
                            self.dbnode[i].animationScaleX = true
                        else
                        
                        end
                    elseif armatureName == "duomei" then
                        if self.dbnode[i].animationScaleX == true then
                            self.dbnode[i]:setScaleX(scale)
                            self.dbnode[i].animationScaleX = false
                        end

                        if animationName == "start3" then
                            animationName = "start1"
                            self.dbnode[i]:setScaleX(-scale)
                            self.dbnode[i].animationScaleX = true
                        elseif animationName == "start7" then
                            animationName = "start5"
                            self.dbnode[i]:setScaleX(-scale)
                            self.dbnode[i].animationScaleX = true
                        elseif animationName == "start11" then
                            animationName = "start9"
                            self.dbnode[i]:setScaleX(-scale)
                            self.dbnode[i].animationScaleX = true
                        elseif animationName == "start13" then
                            animationName = "start12"
                            self.dbnode[i]:setScaleX(-scale)
                            self.dbnode[i].animationScaleX = true
                        elseif animationName == "start17" then
                            animationName = "start16"
                            self.dbnode[i]:setScaleX(-scale)
                            self.dbnode[i].animationScaleX = true
                        elseif animationName == "start15" then
                            animationName = "start14"
                            self.dbnode[i]:setScaleX(-scale)
                            self.dbnode[i].animationScaleX = true
                        else

                        end
                    end
                    --printInfo("---------------timec:")
                    self.dbnode[i]:getAnimation():gotoAndPlay(animationName)
                end
            end
        end
        -- printInfo("------------------time9")
        if  self:getVo().music ~= nil then
            self:audioMgr():playEffect(self:getVo().music,false)
        end

        if  self:getVo().sound ~= nil then
            self:audioMgr():playEffect(self:getVo().sound,false)
        end
        --printInfo("------------------time1")
        self:controlTimer():runWithDelay(function ()
             self:executeFinish()
             self:goDispose()
             --printInfo("------------------time2")
        end,self:getVo().time)

    elseif self:getVo().type == bbfd.COURSE_EVENT_ORDER.MOVE_TO then
        --dump(self.currCouseCtrl)
        local moveObj = self.currCouseCtrl[self:getVo().object]
        if tolua.isnull(moveObj) then
           error("TimerCourseEvent MoveTo obejct is null")
           return 
        end
        local position = {}
        if self:getVo().movePosition ~= nil then
            position = cc.p(moveObj:getPositionX()+self:getVo().movePosition.x,moveObj:getPositionY()+self:getVo().movePosition.y)
        else
            position = cc.p(self:getVo().position.x,self:getVo().position.y)
            if position.x == -1 then
                position.x = moveObj:getPositionX()
            elseif position.y == -1 then
                position.y = moveObj:getPositionY()
            end
        end

        local time = 1
        if self:getVo().time ~= nil then
            time = self:getVo().time
        elseif self:getVo().speed ~= nil then
            local dis = math.sqrt(math.pow( position.x - moveObj:getPositionX() , 2) + math.pow( position.y - moveObj:getPositionY() , 2))
            time = dis/self:getVo().speed
        end
        --printInfo("移动对象："..self:getVo().object)
        --printInfo("移动时间距离："..time)
        local seq = cc.Sequence:create(cc.MoveTo:create(time, position ) ,
                                    cc.CallFunc:create(function()
                                        if self and self:getVo() and self:getVo().fastNext ~= true then
                                            self:executeFinish()
                                        end
                                    end)
                                     )
        moveObj:runAction(seq)
        if self:getVo().fastNext == true then
            self:executeFinish()
        end
    else 
        self:goDispose()
    end
    
end

--执行事件的完成
function BaseCourseEvent:executeFinish()
    self.isFinish_ = true
    if self.parentEventId_ ~= nil then
        --printInfo("BaseCourseEvent:executeFinisha:"..self:getEventId())
        --printInfo("BaseCourseEvent:executeFinishb:"..self.__cname)
        self:evtMgr():Brocast(bbfd.COURSE_EVENT.FINISH,self:getParentEventId())
    else
        self:evtMgr():Brocast(bbfd.COURSE_EVENT.FINISH,self.currCouseCtrl:getCourseName())
    end
end

------------------------------------------------------------------------事件指令类属性
--记录此事件指令是否已完成  一般情况下，完成后调用goDispose()
function BaseCourseEvent:isFinish()
    return self.isFinish_
end

--是否在其他的事件指令中初始化
function BaseCourseEvent:setParentEventId(id)
    self.parentEventId_ = id
end

function BaseCourseEvent:getParentEventId()
   return self.parentEventId_
end

--获取唯一的事件指令id
function BaseCourseEvent:getEventId()
   return self.eventid_
end

function BaseCourseEvent:controlTimer()
    if  self.controlTimer_ == nil then
        self.controlTimer_ = require("bbfd.utils.Timer"):create()
    end
    return self.controlTimer_ 
end

function BaseCourseEvent:courseMgr()
    return bbfd.courseMgr
end

function BaseCourseEvent:evtMgr()
    return bbfd.evtMgr
end

function BaseCourseEvent:uiMgr()
    return bbfd.uiMgr
end

function BaseCourseEvent:audioMgr()
    return bbfd.audioMgr
end

function BaseCourseEvent:getVo()
   return self.vo_
end

function BaseCourseEvent:goDispose()
    self.vo_ = nil
    if  self.controlTimer_ then
        self.controlTimer_:killAll()
    end
    self.controlTimer_ = nil 
end

--endregion
return BaseCourseEvent