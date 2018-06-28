--region *.lua
--Date
--整个课程模块开发框架初始化
--kevin
bbfd = bbfd or {}
require "app.views.Course.CourseConstants"

local CourseManager = require("app.views.Course.CourseManager")
bbfd.courseMgr = CourseManager:getInstance()
bbfd.COURSE_VERSION = 1

local CourseFactory = require("app.views.Course.CourseFactory")
bbfd.courseFactory  = CourseFactory:getInstance()

--endregion