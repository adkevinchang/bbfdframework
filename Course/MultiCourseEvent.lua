--region *.lua
--Date
--[[
事件并行处理的指令类主要包括：（控制并行事件的流程）
--类似课程控制类
]]
--kevin
--
local MultiCourseEvent = class("MultiCourseEvent",require("app.views.Course.BaseCourseEvent"))

function MultiCourseEvent:onCreate(couseCtrl,indx)
   MultiCourseEvent.super.onCreate(self,couseCtrl)
   self.currCouseCtrl = couseCtrl
   self.currMultiIndex = indx
   self:onInit()
end

--并行事件类的初始化
function MultiCourseEvent:onInit() 
    self.currEventVo = nil
    self.currExecEventIndex = 1
    self.totalExecEventNum = table.nums(self:getVo())
    self.currEventOrder = nil
    self.couseEventFinish_ = handler(self,self.couseEventFinishHandle)
    self:evtMgr():AddListener(bbfd.COURSE_EVENT.FINISH,self.couseEventFinish_)
end


function MultiCourseEvent:execute()
end

--外部执行当前子命令
function MultiCourseEvent:executeOperateCourseEvent(btntag)
   printInfo("MultiCourseEvent:executeOperateCourseEvent"..self.currExecEventIndex)
    local tempEventVo = self:getVo()[self.currExecEventIndex]
    if tempEventVo == nil then return end
    printInfo("MultiCourseEvent:executeOperateCourseEvent"..tempEventVo.type)
    if tempEventVo.type == bbfd.COURSE_EVENT_ORDER.CLICK then
       if tempEventVo.click == btntag then
            printInfo("MultiCourseEvent:executeOperateCourseEvent2")
            self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("OperateCourseEvent",self.currEventVo,self.currCouseCtrl)
            if self.currEventOrder ~= nil then
                self.currEventOrder:setParentEventId(self:getEventId())
                self.currEventOrder:execute()
                self.currCouseCtrl["Panel_Button"..btntag]:setVisible(false)
            end
            return true
       end
    end
    return false
end

--启动课程的并行执行事件
function MultiCourseEvent:startUpCourseMultiEvent()
    printInfo("MultiCourseEvent:startUpCourseMultiEvent"..self.currExecEventIndex.."//"..self:getEventId())
    self.currEventVo = self:getVo()[self.currExecEventIndex]
    if self.currEventVo == nil then return end
    --dump(self.currEventVo)
    if self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.SET_FILPPED then
        self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("BaseCourseEvent",self.currEventVo,self.currCouseCtrl,self.currCouseCtrl.dbInteract,self.currCouseCtrl.dbnode)
        -- printInfo("MultiCourseEvent:startUpCourseMultiEvent-SET_FILPPED"..self.currExecEventIndex)
    elseif self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.SET_VISIBLE then
        self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("BaseCourseEvent",self.currEventVo,self.currCouseCtrl,self.currCouseCtrl.dbInteract,self.currCouseCtrl.dbnode)
       --  printInfo("MultiCourseEvent:startUpCourseMultiEvent-SET_VISIBLE"..self.currExecEventIndex)
    elseif self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.SCALE_TO then
        self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("BaseCourseEvent",self.currEventVo,self.currCouseCtrl,self.currCouseCtrl.dbInteract,self.currCouseCtrl.dbnode)
        -- printInfo("MultiCourseEvent:startUpCourseMultiEvent-SCALE_TO"..self.currExecEventIndex)
    elseif self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.SET_POSITION then
        self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("BaseCourseEvent",self.currEventVo,self.currCouseCtrl,self.currCouseCtrl.dbInteract,self.currCouseCtrl.dbnode)
       --  printInfo("MultiCourseEvent:startUpCourseMultiEvent-SET_POSITION"..self.currExecEventIndex)
    elseif self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.SET_SCALE then
        self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("BaseCourseEvent",self.currEventVo,self.currCouseCtrl,self.currCouseCtrl.dbInteract,self.currCouseCtrl.dbnode)
       --  printInfo("MultiCourseEvent:startUpCourseMultiEvent-SET_SCALE"..self.currExecEventIndex)
    elseif self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.SET_OPACITY then
        self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("BaseCourseEvent",self.currEventVo,self.currCouseCtrl,self.currCouseCtrl.dbInteract,self.currCouseCtrl.dbnode)
    elseif self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.TIME then
        self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("BaseCourseEvent",self.currEventVo,self.currCouseCtrl,self.currCouseCtrl.dbInteract,self.currCouseCtrl.dbnode)
        -- printInfo("MultiCourseEvent:startUpCourseMultiEvent-TIME"..self.currExecEventIndex)
    elseif self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.CLICK then
        if self.currCouseCtrl["Panel_Button"..self.currEventVo.click] ~= nil then
             self.currCouseCtrl["Panel_Button"..self.currEventVo.click]:setVisible(true)
        end
        if self.currCouseCtrl["WaitTouch"..self.currEventVo.click] ~= nil then
             self.currCouseCtrl["WaitTouch"..self.currEventVo.click]:setVisible(true)
        end
        self.currEventOrder = nil
        --printInfo("MultiCourseEvent:startUpCourseMultiEvent-CLICK"..self.currExecEventIndex)
    elseif self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.MOVE_TO then
       -- printInfo("MultiCourseEvent:startUpCourseMultiEvent-MOVE_TO"..self.currExecEventIndex)
        self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("BaseCourseEvent",self.currEventVo,self.currCouseCtrl,self.currCouseCtrl.dbInteract,self.currCouseCtrl.dbnode)
    elseif self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.FADE_IN then
       -- printInfo("MultiCourseEvent:startUpCourseMultiEvent-FADE_IN"..self.currExecEventIndex)
        self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("BaseCourseEvent",self.currEventVo,self.currCouseCtrl,self.currCouseCtrl.dbInteract,self.currCouseCtrl.dbnode)
    elseif self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.FADE_OUT then
       -- printInfo("MultiCourseEvent:startUpCourseMultiEvent-FADE_OUT"..self.currExecEventIndex)
        self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("BaseCourseEvent",self.currEventVo,self.currCouseCtrl,self.currCouseCtrl.dbInteract,self.currCouseCtrl.dbnode)
    end

    if self.currEventOrder ~= nil then
    -- printInfo("MultiCourseEvent:startUpCourseMultiEvent-execute"..self.currExecEventIndex)
        self.currEventOrder:setParentEventId(self:getEventId())
        self.currEventOrder:execute()
    end
end

--并行事件每个子事件完成处理
function MultiCourseEvent:couseEventFinishHandle(evetid)
    --printInfo("why------"..self:getEventId())
    --loggerdw("why?")
   if self.isFinish_ then return end

   if self and evetid == self:getEventId() then
       -- dump(self.currEventVo)
        --dump(self.currEventOrder)
        printInfo("MultiCourseEvent:couseEventFinishHandle"..self.currExecEventIndex.."//"..self:getEventId().."//"..self.totalExecEventNum)
        if self.currEventOrder ~= nil then
            self.currEventOrder:goDispose()
            self.currEventOrder = nil
            self.currExecEventIndex = self.currExecEventIndex + 1
        end
       
        --self.currCouseCtrl:initPanelButtons()

        if self.currExecEventIndex <= self.totalExecEventNum then
            self:startUpCourseMultiEvent()
        else 
            --执行，MultiClick nextEvent
            printInfo("bbfd.COURSE_EVENT.MULTI_FINISH")
            self.isFinish_ = true
            self:evtMgr():Brocast(bbfd.COURSE_EVENT.MULTI_FINISH,self:getParentEventId(),self.currMultiIndex)
        end
    end
end

--设置并行处理事件的类型
function MultiCourseEvent:setMultiEventType(ctype)
    self.multiEventType_ = ctype
end

function MultiCourseEvent:getMultiEventType()
   return self.multiEventType_
end

--
function MultiCourseEvent:goDispose()
    self:evtMgr():removeListener(bbfd.COURSE_EVENT.FINISH,self.couseEventFinish_)
    MultiCourseEvent.super.goDispose(self)
    

end
--endregion
return MultiCourseEvent