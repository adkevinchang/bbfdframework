--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
--kevin
local CourseSkipControl = class("CourseSkipControl",require("app.views.Course.CourseControl"))


function CourseSkipControl:onCreate()
	local skipIndex = {
		"s1001","s1002","s1003","s1004","s1005","s2001","s2002","s3001","s3002","s4001","s4002","s5001","s5002","s100_yun"
	}

	local skipSound = {
		1,2,2,3,2,3,3,2,2,2,2,2,3,2
	}
    
	local index = 1
	for i=1,#skipIndex do
		if self:getModel():getSkipType() == skipIndex[i] then
			index = i
			break
		end
	end

	local randNum = math.random(1,skipSound[index])

	local musicName = string.format("skip%02d%02d.mp3",index,randNum)

    self:getModel():setEvent({{type = "PlayOver", aniName = {"start"} ,nextName = {"End"}, music = musicName ,time = 3}})

    CourseSkipControl.super.onCreate(self)
end

--endregion
return CourseSkipControl