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
--bbfd.COURSE_EVENT_ORDER.FADE_IN
--bbfd.COURSE_EVENT_ORDER.PLAY_OVER
--bbfd.COURSE_EVENT_ORDER.TALK_SETTING 
--bbfd.COURSE_EVENT_ORDER.MOVE_BY
--bbfd.COURSE_EVENT_ORDER.MOVE_MAP

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

--dbobj 交互对象
--couseCtrl 当前课程控制对象
--dbnodea 动画播放对象 
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
     printInfo("BaseCourseEvent:execute  " .. self:getVo().type)
     if self:getVo().type == bbfd.COURSE_EVENT_ORDER.SET_FILPPED then
         self:playSomeAniName()
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
        self:playSomeAniName()
        local scale = self:getVo().scale
        if not tolua.isnull(self.currCouseCtrl[self:getVo().object]) then
            self.currCouseCtrl[self:getVo().object]:setScale(scale)
        end
        
        self:executeFinish()
        self:goDispose()
    elseif self:getVo().type == bbfd.COURSE_EVENT_ORDER.PLAY_OVER then
            --printInfo("=============================================")
            --dump(self:getVo().nextName)
            if  self:getVo().music ~= nil then
                self:audioMgr():playEffect(self:getVo().music,false)
            end

            if self:getVo().aniName ~= nil then
                local eventAniName = {}
                if type(self:getVo().aniName) == "string" then
                    table.insert(eventAniName,self:getVo().aniName)
                else
                    eventAniName = self:getVo().aniName
                end

                for i=1,#eventAniName do
                    if eventAniName[i] ~= nil and eventAniName[i] ~= "" and self.dbnode[i] ~=nil and self.dbnode[i].animationName ~= eventAniName[i] then
                        self.dbnode[i]:setVisible(true)
                        self.dbnode[i].animationName = eventAniName[i]
                        self.dbnode[i]:getAnimation():clear()
                        self.dbnode[i]:getAnimation():gotoAndPlay(self.dbnode[i].animationName)
                        self.dbnode[i]:registerAnimationEventHandler(handler(self,self.bonesEvent))
                    end
                end
            end
    elseif self:getVo().type == bbfd.COURSE_EVENT_ORDER.SET_OPACITY then
        self:playSomeAniName()
        local opacity = self:getVo().opacity
        if not tolua.isnull(self.currCouseCtrl[self:getVo().object]) then
            self.currCouseCtrl[self:getVo().object]:setOpacity(opacity)
        end
        self:executeFinish()
        self:goDispose()
    elseif self:getVo().type == bbfd.COURSE_EVENT_ORDER.SET_VISIBLE then
        self:playSomeAniName()
        local targetObj = self.currCouseCtrl[self:getVo().object]
        targetObj:setVisible(self:getVo().visible)
        self:executeFinish()
        self:goDispose()
    elseif self:getVo().type == bbfd.COURSE_EVENT_ORDER.SCALE_TO then
        self:playSomeAniName()
        local targetObj = self.currCouseCtrl[self:getVo().object]
        dump(targetObj)
        local seq = cc.Sequence:create(cc.ScaleTo:create(self:getVo().time,self:getVo().scale),
                                    cc.CallFunc:create(function()
                                        if self:getVo()~= nil and self:getVo().fastNext ~= true then
                                            self:executeFinish()
                                            self:goDispose()
                                        end
                                    end)
                                     )
        targetObj:runAction(seq)
        if self:getVo()~= nil and self:getVo().fastNext == true then
            self:executeFinish()
            self:goDispose()
        end
    elseif self:getVo().type == bbfd.COURSE_EVENT_ORDER.SET_POSITION then
        self:playSomeAniName()
        self.currCouseCtrl[self:getVo().object]:setPosition(self:getVo().position.x,self:getVo().position.y)--dbnode5
        --dump(self.currCouseCtrl[self:getVo().object])
        self:executeFinish()
        self:goDispose()
	elseif self:getVo().type == bbfd.COURSE_EVENT_ORDER.FADE_IN then
        -- printInfo("-----------------------bbfd.COURSE_EVENT_ORDER.FADE_IN")
        local object = self.currCouseCtrl[self:getVo().object]
        -- dump(self:getVo())
        local getVo = self:getVo()
        local seq = cc.Sequence:create(cc.FadeIn:create(self:getVo().time),
                                    cc.CallFunc:create(function()
                                        -- dump(self:getVo())
                                        if getVo ~= nil and getVo.fastNext ~= true then
                                            self:executeFinish()
                                             self:goDispose()
                                        end
                                    end)
                                     )
        object:runAction(seq)

       if self:getVo()~= nil and self:getVo().fastNext == true then
            self:executeFinish()
             self:goDispose()
        end
    elseif self:getVo().type == bbfd.COURSE_EVENT_ORDER.FADE_OUT then
        self:playSomeAniName()
        -- printInfo("-----------------------bbfd.COURSE_EVENT_ORDER.FADE_IN")
        local object = self.currCouseCtrl[self:getVo().object]
        -- dump(self:getVo())
        local getVo = self:getVo()
        local seq = cc.Sequence:create(cc.FadeOut:create(self:getVo().time),
                                    cc.CallFunc:create(function()
                                        -- dump(self:getVo())
                                        if getVo ~= nil and getVo.fastNext ~= true then
                                            self:executeFinish()
                                             self:goDispose()
                                        end
                                    end)
                                     )
        object:runAction(seq)

       if self:getVo()~= nil and self:getVo().fastNext == true then
            self:executeFinish()
             self:goDispose()
        end
       
    elseif  self:getVo().type == bbfd.COURSE_EVENT_ORDER.TIME then
        --printInfo("------------------------------------------------bbfd.COURSE_EVENT_ORDER.TIME")
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
        self:playSomeAniName()

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
                                            self:goDispose()
                                        end
                                    end)
                                     )
        moveObj:runAction(seq)
        if self:getVo().fastNext == true then
            self:executeFinish()
            self:goDispose()
        end
	elseif self:getVo().type == bbfd.COURSE_EVENT_ORDER.MOVE_BY then
		self:onMoveBy()
    else 
        self:executeFinish()
        self:goDispose()
    end
    
end

--播放通用的动画
function BaseCourseEvent:playSomeAniName()
    if self:getVo().aniName ~= nil then
       local eventAniName = {}
       if type(self:getVo().aniName) == "string" then
             table.insert(eventAniName,self:getVo().aniName)
       else
       eventAniName = self:getVo().aniName
       end

       for i=1,#eventAniName do
          if eventAniName[i] ~= nil and eventAniName[i] ~= "" and self.dbnode[i] ~=nil and self.dbnode[i].animationName ~= eventAniName[i] then
               self.dbnode[i]:setVisible(true)
               self.dbnode[i].animationName = eventAniName[i]
               self.dbnode[i]:getAnimation():clear()
               self.dbnode[i]:getAnimation():gotoAndPlay(self.dbnode[i].animationName)
          end
       end
    end
end

--对话设置
function BaseCourseEvent:onTalkSetting()
    self:playSomeAniName()
	for i=1,#self:getVo().active do
		local active = self:getVo().active[i]
		if active == true then
			if self:getVo().position[i].x < 0 then
				self.dbnode[i][1]:setVisible(true)
				self.dbnode[i][2]:setVisible(false)
				
				self.dbnode[i][1]:setPosition(self:getVo().position[i])
			else
				self.dbnode[i][1]:setVisible(false)
				self.dbnode[i][2]:setVisible(true)

				self.dbnode[i][2]:setPosition(self:getVo().position[i])
			end
		else
			self.dbnode[i][1]:setVisible(false)
			self.dbnode[i][2]:setVisible(false)
		end
	end

	self:executeFinish()
    self:goDispose()
end

--moveBy
function BaseCourseEvent:onMoveBy()
    self:playSomeAniName()
	local moveObj = self.currCouseCtrl[self:getVo().object]

    local position = {}
    position = cc.p(self:getVo().position.x,self:getVo().position.y)

	local time = 1
	if self:getVo().time ~= nil then
		time = self:getVo().time
	elseif event.speed ~= nil then
		local dis = math.sqrt(math.pow( position.x , 2) + math.pow( position.y , 2))
		time = dis/event.speed
	end

	local seq = cc.Sequence:create(cc.MoveBy:create(time, position ) ,
                                    cc.CallFunc:create(function()
                                        if self and self:getVo() and self:getVo().fastNext ~= true then
                                            self:executeFinish()
                                            self:goDispose()
                                        end
                                    end)
                                     )
	moveObj:runAction(seq)

	if self:getVo().fastNext == true then
		self:executeFinish()
        self:goDispose()
	end
end

function BaseCourseEvent:onMoveMap()
    self:playSomeAniName()
    local mapName = self.currCouseCtrl():getModel():getMapName()
	local mapBg = {self.currCouseCtrl[self.dbnode[1]],self.currCouseCtrl[self.dbnode[2]],self.currCouseCtrl[self.dbnode[3]]}
	local role = self.currCouseCtrl[self:getVo().object]

    local mapX = self:getVo().mapX
    local time = 1
    if self:getVo().time ~= nil then
		time = self:getVo().time
    elseif self:getVo().speed ~= nil then
		time = math.abs(mapX/self:getVo().speed)
    end

	--3个滚轴
	--mapBg[1]:runAction(cc.MoveBy:create(time, cc.p(mapX*0.5,0)))
	mapBg[2]:runAction(cc.MoveBy:create(time, cc.p(mapX,0)))
	mapBg[3]:runAction(cc.MoveBy:create(time, cc.p(mapX*1.5,0)))

	self.currCouseCtrl["Panel_All"]:runAction(cc.MoveBy:create(time, cc.p(mapX,0)))

	role:runAction(cc.MoveBy:create(time, cc.p(-mapX,0)))

	self:controlTimer():runWithDelay(function ()
		self:executeFinish()
        self:goDispose()
    end,time)
end

function BaseCourseEvent:bonesEvent(event)
    --printInfo("===bonesEvent1")
    if event.type == 7 then
        --printInfo("===bonesEvent2")
        self:executeFinish()
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