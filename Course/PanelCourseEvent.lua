--region *.lua
--Date
--[[
操作面板事件指令类主要包括：（可扩展可加逻辑）
--bbfd.COURSE_EVENT_ORDER.TITLE_EVENT
]]
--kevin

local PanelCourseEvent = class("PanelCourseEvent",require("app.views.Course.BaseCourseEvent"))
--主要事件指令类型 TitleEvent {type = "TitleEvent" , enterType = "Right", exitType = "Left", enterTime = 0.5, exitTime = 0.3, title = "情绪心理：自信魔法",showTime = 4 , fontColor = cc.c3b(252,254,40) , fontScale = 1.0, music = "tittle_qingxu0105.mp3"}

function PanelCourseEvent:execute()
    --printInfo("PanelCourseEvent:execute".. self:getVo().type)
    if self:getVo().type == bbfd.COURSE_EVENT_ORDER.TITLE_EVENT then
         if self:courseMgr():getIdentity() == bbfd.COURSE_IDENTITY.TEACHER then
            --printInfo("教师端不显示学习目标")
            self:executeFinish()
            self:goDispose()
        else
             local set =  cc.Director:getInstance():getActionManager():pauseAllRunningActions()
             local index = 3
             for i,v in ipairs(EducationPointData.Sheet1) do
                if BrainsData.Current.GameName == v[EducationPointData.Sheet1.switch.TaskID] then
                    index = i
                    break
                end
             end
             local info = EducationPointData.Sheet1[index]  --根据gameID来选择
             local EdLayer = require("app.brainsGame.EducationPoint").create()
             EdLayer:changeByInfo(info,set,nil,true)
             self:uiMgr():getPanelLayer():addChild(EdLayer)

             --printInfo(self:getVo().music)
             self:audioMgr():playEffect(self:getVo().music,false)
             self:controlTimer():runWithDelay(function ()
                 --self:evtMgr():Brocast(bbfd.COURSE_EVENT.FINISH,self.currCouseCtrl)
                  --printInfo("bbfd.COURSE_EVENT.FINISH")
                  self:executeFinish()
             end,self:getVo().showTime)
        end
    end
    
    
end

--endregion
return PanelCourseEvent