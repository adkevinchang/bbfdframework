--region *.lua
--Date
--[[
当前课程的流程管理类
    local gameName = BrainsData.Current.GameName
    local gameData = BrainsData[gameName]
    --课程新框架判断
    if gameData.version and gameData.version == 1 then
        bbfd.courseMgr:playNextCourseNode()
        return
    end
]]
--kevin
local CourseManager = class("CourseManager")
CourseManager.instance = nil;

function CourseManager:getInstance()
   if not CourseManager.instance then
      CourseManager.instance = CourseManager:create()
      self:initCourseManager()
   end
   return CourseManager.instance;
end

--------------------------------------------------------------------课程流程初始化
function CourseManager:initCourseManager()
   self.currCourseData = nil
   self.currCourseName_ = ""

end

---------------------------------------------------------------------课程播放逻辑
function CourseManager:playCourse(courseName)
   --loggerGameLog(courseName.." --CourseManager:playCourse")
   self.currPlayStep = 1
   self.currCourseData = BrainsData[courseName]
   self.currCourseName_ = courseName
   dump(self.currCourseData)
   --预加载课程并进入下一个课程场景
   bbfd.uiMgr:initScene(display.getRunningScene())
   bbfd.uiMgr:showLoadAction(true)
   if self.currCourseData.PreLoadingFile ~= nil then
      bbfd.downMgr:AsyncDownAssets(function()
                bbfd.uiMgr:showLoadAction(false)
                self:playNextScene()
                end,self.currCourseData.PreLoadingFile)
   else
       bbfd.uiMgr:showLoadAction(false)
       self:playNextScene()
   end

end

--播放下一个课程环节
function CourseManager:playNextCourseNode()
    bbfd.audioMgr:stopMusic()
    --待优化
    self.currPlayStep = self:findNodePrevIndex()
    self.currPlayStep =  self.currPlayStep + 1
    self:playNextScene()
end

--播放上一个课程环节
function CourseManager:playPrevCourseNode()
    --待优化
    bbfd.audioMgr:stopMusic()
    self.currPlayStep = self:findNodePrevIndex()
    self.currPlayStep = self.currPlayStep - 1
    if self.currPlayStep < 1 then
        --error("course data is wrong - CourseManager:playPrevCourseNode！")
        self.currPlayStep  = 1
        self:replayNowCourseNode()
        return 
    end
    self:playNextScene()
end


--播放当前课程环节场景
function CourseManager:replayNowCourseNode()
   self:playNextScene()
end

--播放下一个课程环节场景
function CourseManager:playNextScene()
    --printInfo("CourseManager:playNextScene")
    
    local currSceneName = nil
    if self:getIdentity() == bbfd.COURSE_IDENTITY.STUDENT then
        if  self.currCourseData ~= nil and  self.currCourseData.ViewOrder ~= nil then
            currSceneName = self.currCourseData.ViewOrder[self.currPlayStep]
            printInfo("CourseManager:playNextScene1"..self.currPlayStep)
        end
    else
        if  self.currCourseData ~= nil and  self.currCourseData.viewOrderT ~= nil then
            currSceneName = self.currCourseData.viewOrderT[self.currPlayStep]
            printInfo("CourseManager:playNextScene2"..self.currPlayStep)
        else 
           currSceneName = self.currCourseData.ViewOrder[self.currPlayStep]
           printInfo("CourseManager:playNextScene3"..self.currPlayStep)
        end
    end

    --根据配置选择播放新框架的课程环节还是旧的课程环节
    local playabled = self:checkCourseNodeProp(currSceneName)
    if playabled then return end

   -- printInfo("CourseManager:currSceneName3"..currSceneName)
    if  currSceneName ~= nil then

        BrainsData.Current.SceneName = currSceneName
        printInfo(self.currPlayStep)
        printInfo(BrainsData.Current.SceneName)
        --dump(self.currCourseData.ViewOrder)
        if  BrainsData.Current.SceneName == bbfd.COURSE_END_SCENE then
           -- printInfo("CourseManager:COURSE_END_SCENE")
           local layer = require("app.views.studyHall.StudyResultView").create()
           local newScene = display.newScene("StudyResultView")
           newScene:addChild(layer)
           display.runScene(newScene)
           return
        else
            local currplayvo =  self.currCourseData[BrainsData.Current.SceneName]
            printInfo("CourseManager:playNextScene1:"..currplayvo.type)
            printInfo("CourseManager:playNextScene2:"..BrainsData.Current.SceneName)
            if currplayvo.type == bbfd.COURSE_TYPE.BASE then
                if currplayvo.model == bbfd.COURSE_MODEL.BASE then
                    bbfd.courseFactory:productBaseModel(currplayvo)
                elseif currplayvo.model == bbfd.COURSE_MODEL.MUSIC_SCORE then
                    bbfd.courseFactory:productMusicScoreModel(currplayvo)
                elseif currplayvo.model == bbfd.COURSE_MODEL.GAME_SKIP_MODEL then
                    bbfd.courseFactory:productGameSkipModel(currplayvo)
                end
            else

            end
        end
        --currplayvo.type
        --currplayvo.model
        
    else
       loggerGameLog("course data no have! --CourseManager:playNextScene")
    end
    --self.currCourseControl = StartupGameControl("Course","",gameData)

end

--检查新旧课程环节属性
function CourseManager:checkCourseNodeProp(cousenm)
    self:setOldCouseNode(false)
    if cousenm == nil then return false end
    local currplayvo =  self.currCourseData[cousenm]
    if currplayvo == nil then return false end
    if currplayvo.model == bbfd.COURSE_MODEL.BASE or currplayvo.model == bbfd.COURSE_MODEL.GAME_SKIP_MODEL then
        printInfo("checkCourseNodeProp:new")
        return false
    else
        printInfo("checkCourseNodeProp:old")
        self:setOldCouseNode(true)
        if self:getIdentity() == bbfd.COURSE_IDENTITY.STUDENT then
             BrainsGameManager.EnterNextScene_S()
        else
             BrainsGameManager.EnterNextScene_T()
        end
        return true
    end
    return false
end

function CourseManager:findNodePrevIndex()
    if self:getIdentity() == bbfd.COURSE_IDENTITY.STUDENT then
        local passStep = 0      
        if BrainsData.Current.SceneName == nil then
            passStep = 0
        else
        for i=1,#self.currCourseData.ViewOrder do
            if BrainsData.Current.SceneName == self.currCourseData.ViewOrder[i] then
                passStep = i
                break
            end
        end

        --找不到对应的名字
        if passStep == 0 then
            passStep = BrainsData.Current.step
        end
        return passStep
        end
    else
        local passStep = 0      
        if BrainsData.Current.SceneName == nil then
            passStep = 0
        else
        local currorder = nil
        if self.currCourseData.viewOrderT ~= nil then
            currorder = self.currCourseData.viewOrderT
        else
            currorder = self.currCourseData.ViewOrder
        end
        for i=1,#currorder do
            if BrainsData.Current.SceneName == currorder[i] then
                passStep = i
                break
            end
        end

        --找不到对应的名字
        if passStep == 0 then
            passStep = BrainsData.Current.step
        end
        return passStep
        end
     end
    return 1
end

----------------------------------------------------------------------------未下载的课程
function CourseManager:downCourse()

end

----------------------------------------------------------------------------属性
--获取课程信息
function CourseManager:getCourseData()
   return self.currCourseData
end

function CourseManager:setCourseMenu(indx)
   self.currCoureMenu_ = indx
end

function CourseManager:getCourseMenu()
   return self.currCoureMenu_
end

--当前课程名
function CourseManager:getCurrCourseNm()
   return self.currCourseName_ 
end

--设置课程环节是新还是旧
function CourseManager:setOldCouseNode(olded)
   self.courseOldCouseNode_ = olded
end

function CourseManager:getOldCouseNode()
   if self.courseOldCouseNode_ == nil then return false end
   return self.courseOldCouseNode_
end

--设置课程身份
function CourseManager:setIdentity(info)
   self.courseIdentity = info
end

function CourseManager:getIdentity()
   return self.courseIdentity
end


--endregion
return CourseManager
