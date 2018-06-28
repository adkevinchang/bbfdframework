--region *.lua
--Date
--[[
所有课程模块的创建工厂
---- Course  +++++++++++++++++基础课程模块
]]
--kevin
local CourseFactory =  class("CourseFactory")
CourseFactory.instance = nil;

function CourseFactory:getInstance()
   if not CourseFactory.instance then
      CourseFactory.instance = CourseFactory:create()
   end
   return CourseFactory.instance;
end

--创建课程的基础模块
function CourseFactory:productBaseModel(couseModelVo,...)
   StartupGameControl("Course","CourseView",couseModelVo,...)
end

--创建乐谱课程模块
function CourseFactory:productMusicScoreModel(couseModelVo,...)
   StartupGameControl("MusicScoreCourse","MusicScoreCourseView",couseModelVo,...)
end

--创建课程指定事件类型
function CourseFactory:createCourseEventOrder(ordernm,ordervo,...)
    return require("app.views.Course."..ordernm):create(ordervo,...)
end

--endregion
return CourseFactory