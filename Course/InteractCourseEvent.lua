--region *.lua
--Date
--[[
交互动作事件指令类主要包括：（点击播放动画不打断主事件流程）
--bbfd.COURSE_EVENT_ORDER.TIME
]]
--kevin
--交互动作事件指令
local InteractCourseEvent = class("InteractCourseEvent",require("app.views.Course.BaseCourseEvent"))
--   {type = "Time", time = 6, interactName = {"right0","","",""}},
--   {type = "Time", time = 1, interactName = {"start0","","",""}},

function InteractCourseEvent:onCreate(couseCtrl,dbobj,dbnodea)
    self.dbInteract = dbobj
end

function InteractCourseEvent:execute()
    if  self:getVo() ~= nil then
        printInfo("InteractCourseEvent:execute")
        dump(self:getVo())
        local startvo = self:getVo()[1] --交互事件，结束时回到之前状态
        local endvo = self:getVo()[2]

        if startvo.type == bbfd.COURSE_EVENT_ORDER.TIME then
            if startvo ~= nil then
               if startvo.interactName ~= nil then
                    local eventAniName = startvo.interactName
                    for i=1,#eventAniName do
                        if eventAniName[i] ~= nil and eventAniName[i] ~= "" and not tolua.isnull(self.dbInteract[i])then
                            self.dbInteract[i]:setVisible(true)
                            self.dbInteract[i]:getAnimation():clear()
                            self.dbInteract[i]:getAnimation():gotoAndPlay(eventAniName[i])
                            printInfo(i.."//"..eventAniName[i])
                        end
                    end
               end
               if endvo ~= nil then
                     self:controlTimer():runWithDelay(function ()
                         if endvo.interactName ~= nil then
                            local eventAniName = endvo.interactName
                            for i=1,#eventAniName do
                                if eventAniName[i] ~= nil and eventAniName[i] ~= "" and not tolua.isnull(self.dbInteract[i]) then
                                    self.dbInteract[i]:setVisible(true)
                                    self.dbInteract[i]:getAnimation():clear()
                                    self.dbInteract[i]:getAnimation():gotoAndPlay(eventAniName[i])
                                     printInfo(i.."//"..eventAniName[i])
                                end
                            end
                       end
                     end,startvo.time)
               else
                  self:goDispose()
               end
            else
               self:goDispose()
            end
        end
    end
end

--endregion
return InteractCourseEvent