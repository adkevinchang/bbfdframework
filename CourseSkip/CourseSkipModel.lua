--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
--kevin
local CourseSkipModel = class("CourseSkipModel",require("app.views.Course.CourseModel"))

function CourseSkipModel:onCreate()
     self:getVo()["bonesFile"] = self:getSkipType()
	 self:getVo()["armatureName"] = self:getSkipType()
end

--获取过程类型
function CourseSkipModel:getSkipType()
   return self:getVo()["skipType"]
end

function CourseSkipModel:setEvent(eventvo)
   self:getVo()["event"] = eventvo
end

--endregion
return CourseSkipModel