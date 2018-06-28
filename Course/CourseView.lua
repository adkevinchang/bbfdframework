--region *.lua
--Date
--课程基础模块的VIEW表现类
--kevin
local CourseView = class("CourseView",require("bbfd.scenes.BaseScene"))

-----------------------------------------------------------------------------动态初始化ui csb
function CourseView:onCreate(courseinfo)
    display.loadSpriteFrames("gameCommon.plist","gameCommon.png")
    display.loadSpriteFrames("Common/commonUI.plist","Common/commonUI.png")
	self.csbFile = ""..BrainsData.Current.GameName.."/"..BrainsData.Current.SceneName.."Scene.csb"
    --printInfo(csbFile)
    if courseinfo and courseinfo == "GameSkipModel" then
        self.csbFile = "gameSkipScene.csb"
    end
    if self.csbFile then
        self:createResourceNode(self.csbFile)
    end
    --dump(self.resourceNode_,"self.resourceNode_")
    DisplayUtil:parseChildrenName(self,self.resourceNode_)
    printInfo("CourseView:onCreate"..self.csbFile)
end

function CourseView:showWithScene(transition, time, more)
   -- printInfo("CourseView:showWithScene1")
    CourseView.super.showWithScene(self)
    local scene = self:poolMgr():getFromPool("CCScene")
    scene.name_ = "CourseBaseModelScene"
    self:uiMgr():initTraScene(scene,time)
    self:uiMgr():getGameLayer():addChild(self)
    display.runScene(scene, transition, time, more)
   -- printInfo("CourseView:showWithScene2")
end

-------------------------------------------------------------------------------背景配置布局
--所有元素的适配在这里
function CourseView:initLayout()
   printInfo("CourseView:initLayout")

end

function CourseView:goDispose()
    CourseView.super.goDispose(self)
    printInfo("CourseView:goDispose")

end

--endregion
return CourseView