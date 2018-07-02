--region *.lua
--Date
--[[
操控动作事件指令类主要包括：（控制主事件的流程）
--bbfd.COURSE_EVENT_ORDER.CLICK
--bbfd.COURSE_EVENT_ORDER.MULTI_CLICK
]]
--kevin
--
local OperateCourseEvent = class("OperateCourseEvent",require("app.views.Course.BaseCourseEvent"))

--如果是多点触发则初始化
--记录多点并发事件的一些初始化数据
function OperateCourseEvent:onInit() 
    if self:getVo().type == bbfd.COURSE_EVENT_ORDER.MULTI_CLICK then
        self.couseEventFinish_ = handler(self,self.couseEventFinishHandle)
        self:evtMgr():AddListener(bbfd.COURSE_EVENT.MULTI_FINISH,self.couseEventFinish_)
        local multidata = self:getVo().data
        local multinextEvent = self:getVo().nextEvent
        self.multiEventFinishNum = 0
        self.multiEventDataNums = table.nums(multidata)
        self.multiEventTable = {}
        self.multiNextEventNums = 0 
        if multinextEvent ~= nil then
            for i,v in ipairs(multinextEvent) do
                if #v >0 then
                    self.multiNextEventNums = self.multiNextEventNums + 1
                end
            end
        end

        self.multiEventTotalNums = self.multiEventDataNums + self.multiNextEventNums
    end
end

function OperateCourseEvent:execute()
  -- printInfo("OperateCourseEvent:execute1")
   if self:getVo() ~= nil then
       if self:getVo().type == bbfd.COURSE_EVENT_ORDER.CLICK then
           -- printInfo("-----------------------------------------------OperateCourseEvent-bbfd.COURSE_EVENT_ORDER.CLICK")
            self:executeFinish()
            self:goDispose()
       elseif self:getVo().type == bbfd.COURSE_EVENT_ORDER.MULTI_CLICK then
            --data,nextEvent
            
            local multidata = self:getVo().data
           -- printInfo(" OperateCourseEvent:execute"..#multidata)

            for i=1,#multidata do
              -- printInfo("kevin:"..i)
               if multidata[i] ~= nil then
                   local evtorder = bbfd.courseFactory:createCourseEventOrder("MultiCourseEvent",multidata[i],self.currCouseCtrl,i)
                   self.multiEventTable[i] = evtorder
                   evtorder:setParentEventId(self:getEventId())
                   evtorder:setMultiEventType(bbfd.COURSE_MULTI_TYPE.EVENT_DATA)
                   evtorder:startUpCourseMultiEvent()
                   --printInfo("kevin:"..i.."end")
               end
               
              -- printInfo(" OperateCourseEvent:executeMultiCourseEvent:"..i)
            end

       end
   end
end

--indx 如果为数字则是data阶段的MultiCourseEvent派发的事件
--indx 如果为nil则是nextEvent阶段的MultiCourseEvent派发的事件
--多点并发事件指令完成执行，1.单点指定执行事件（data）2.随机多点，按顺序执行事件(nextEvent)
function OperateCourseEvent:couseEventFinishHandle(evetid,indx)
    printInfo("OperateCourseEvent:couseEventFinishHandle")
    if self and evetid == self:getEventId() then
       if self.multiNextEventNums == 0 then
            self.multiEventFinishNum = self.multiEventFinishNum + 1
            if self:checkDataAllFinish() then
                printInfo("OperateCourseEvent:couseEventFinishHandle4")
                self:executeFinish()
                return
            end
       end
       local multinextEvent = self:getVo().nextEvent

       if indx ~= nil then
           printInfo("OperateCourseEvent:couseEventFinishHandle2:".. self.multiEventFinishNum)
           self.multiEventFinishNum = self.multiEventFinishNum + 1
           local cne = multinextEvent[self.multiEventFinishNum]
           if cne ~= nil and #cne >0 then
                printInfo("OperateCourseEvent:couseEventFinishHandle3")
                local evtorder = bbfd.courseFactory:createCourseEventOrder("MultiCourseEvent",cne,self.currCouseCtrl)
                self.multiEventTable[#self.multiEventTable+1] = evtorder
                self.multiEventTotalNums = #self.multiEventTable
                evtorder:setParentEventId(self:getEventId())
                evtorder:setMultiEventType(bbfd.COURSE_MULTI_TYPE.EVENT_NEXT_EVENT)
                evtorder:startUpCourseMultiEvent()
           end
       end

       --data nextevent一样多时 点击哪个执行哪个next,直到都执行完
       if self:checkNextEventAllFinish() then
           printInfo("OperateCourseEvent:couseEventFinishHandle1")
           self:executeFinish()
           self:goDispose()
           return
       end

       printInfo("OperateCourseEvent:couseEventFinishHandlefff"..self.multiEventFinishNum.."//"..self.multiEventTotalNums)
    end
end

--检查事件对象是否全部完成
function OperateCourseEvent:checkDataAllFinish()
    local num = 0
    for i,v in ipairs(self.multiEventTable) do
        --printInfo("OperateCourseEvent:checkDataAllFinish1")
        if v:isFinish() then
            -- printInfo("OperateCourseEvent:checkDataAllFinish2")
            --self.multiEventDataNums  getMultiEventType
            if v:getMultiEventType() ==  bbfd.COURSE_MULTI_TYPE.EVENT_DATA then
                num = num + 1
                -- printInfo("OperateCourseEvent:checkDataAllFinish3"..num.."//"..self.multiEventDataNums)
                if num == self.multiEventDataNums  then
                    return true
                end
            end
        end
    end
    return false
end

--检查下一个事件对象是否全部完成
function OperateCourseEvent:checkNextEventAllFinish()
   local num = 0
   for i,v in ipairs(self.multiEventTable) do
      --  printInfo("OperateCourseEvent:checkNextEventAllFinish1")
        if v:isFinish() then
            --self.multiNextEventNums getMultiEventType
           -- printInfo("OperateCourseEvent:checkNextEventAllFinish2"..v:getMultiEventType())
             if v:getMultiEventType() ==  bbfd.COURSE_MULTI_TYPE.EVENT_NEXT_EVENT then
                num = num + 1
                 --printInfo("OperateCourseEvent:checkNextEventAllFinish2"..num.."//"..self.multiNextEventNums)
                if num == self.multiNextEventNums  then
                    return true
                end
            end
        end
    end
    return false
end

--启动点击操作课程事件
function OperateCourseEvent:startUpOperateCourseEvent(btntag)
     printInfo("OperateCourseEvent:startUpOperateCourseEvent")
     if self.multiEventTable == nil then return end
     for i,v in ipairs(self.multiEventTable) do 
         if v ~= nil then
            local clickable = v:executeOperateCourseEvent(btntag)  
            if clickable then return end
         end    
     end
end

function OperateCourseEvent:goDispose()
    if self.multiEventTable ~= nil then
        self:evtMgr():removeListener(bbfd.COURSE_EVENT.MULTI_FINISH,self.couseEventFinish_)
        for i,v in ipairs(self.multiEventTable) do 
           v:goDispose()
        end
        self.multiEventTable = nil
    end

    OperateCourseEvent.super.goDispose(self)
   

end

--endregion
return OperateCourseEvent