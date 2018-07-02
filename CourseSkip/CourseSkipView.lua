--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
--kevin
local CourseSkipView = class("CourseSkipView",require("app.views.Course.CourseView"))

function CourseSkipView:onCreate(courseinfo)
    display.loadSpriteFrames("gameCommon.plist","gameCommon.png")
    display.loadSpriteFrames("Common/commonUI.plist","Common/commonUI.png")
	self.csbFile = "gameSkipScene.csb"

    if self.csbFile then
        self:createResourceNode(self.csbFile)
    end
    --dump(self.resourceNode_,"self.resourceNode_")
    DisplayUtil:parseChildrenName(self,self.resourceNode_)
    printInfo("CourseSkipView:onCreate:"..self.csbFile)
end

function CourseSkipView:showWithScene(transition, time, more)
    CourseSkipView.super.showWithScene(self,transition, time, more)
    printInfo("CourseSkipView:showWithScene")
end
 

--endregion
return CourseSkipView
