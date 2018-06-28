--region *.lua
--Date
--[[
定时事件指令类主要包括：（可扩展可加逻辑）
--bbfd.COURSE_EVENT_ORDER.LOADING_BAR
]]
--所有跟定时处理相关的事件指令
--kevin
local TimerCourseEvent = class("TimerCourseEvent",require("app.views.Course.BaseCourseEvent"))

function TimerCourseEvent:onCreate(couseCtrl)
    TimerCourseEvent.super.onCreate(self,couseCtrl)
    self.updateEventTime = 0

end

--如要定时处理的事件指令类型
function TimerCourseEvent:execute(dt)
   if self:getVo().type == bbfd.COURSE_EVENT_ORDER.LOADING_BAR then
       self.updateEventTime = self.updateEventTime + dt
       --printInfo("updateEventTime：".. self.updateEventTime)
       --如果到了进度时间
       if self.updateEventTime >= self:getVo().time and self.updateEventTime - dt < self:getVo().time then
           if not tolua.isnull(self.currCouseCtrl[self:getVo().object]) then
                 self.currCouseCtrl[self:getVo().object]:setPercent(100)
                 self:executeFinish()
           else
               loggerGameLog(self:getVo().object..":no find Object!--TimerCourseEvent:execute")
           end
           return 
       end

       if self.updateEventTime <= self:getVo().time then
           if not tolua.isnull(self.currCouseCtrl[self:getVo().object]) then
                 local percent = 100*self.updateEventTime/self:getVo().time
                 self.currCouseCtrl[self:getVo().object]:setPercent(percent)
           else
               loggerGameLog(self:getVo().object..":no find Object!--TimerCourseEvent:execute")
           end
       end
   end
end

--endregion
return TimerCourseEvent