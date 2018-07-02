--region *.lua
--Date
--此文件课程模块的基础类
--[[
基础模块主要包括：
--主事件指令类型的启动与完成逻辑处理
--实时函数的定义处理，处理定时事件指令类型
--交互事件指令类型的处理
--点击执行指令类型的处理
]]
--kevin
local CourseControl = class("CourseControl",require("bbfd.scenes.BaseSceneControl"))

function CourseControl:onCreate()
   --可扩展以及重写课程的基本信息和角色
   CourseControl.super.onCreate(self)
   --主事件课程完成
   self.couseEventFinish_ = handler(self,self.couseEventFinishHandle)
   self:evtMgr():AddListener(bbfd.COURSE_EVENT.FINISH,self.couseEventFinish_)
   printInfo("CourseControl:onCreate"..self.bbfdId)
   self:setCourseName(bbfd.courseMgr:getCurrCourseNm()..BrainsData.Current.SceneName)
end

function CourseControl:initFunMod(viewname,modelvo,...)
    CourseControl.super.initFunMod(self,viewname,modelvo,...)
    local  transition_ = {nil,nil,nil}
    if self:getModel():getVo().transition ~= nil then
         transition_ = self:getModel():getVo().transition
    end
    self:getView():showWithScene(transition_[1],transition_[2],transition_[3])
end

-----------------------------------------------------------------------------基础课程模块初始化
--goEnter可多次进入 判断view的初始化即可
function CourseControl:goEnter(view)
    printInfo("CourseControl:goEnter")
    if not tolua.isnull(self:getView()) and not tolua.isnull(view) then
        CourseControl.super.goEnter(self) 
        printInfo("CourseControl:goEnter1")
        if self:getView():isInitScene() == false then
        printInfo("CourseControl:goEnter2")
            self:initCourseUI()
            self:initCourseInfo()
            self:initCourseUpdate()
            self:startUpCourseEvent()
        end
    end
    --self:startUpInteractCourseEvent
end

function CourseControl:goDispose()
    CourseControl.super.goDispose(self)
    self:evtMgr():removeListener(bbfd.COURSE_EVENT.FINISH,self.couseEventFinish_)
    self.dbInteract = nil
    printInfo("CourseControl:goDispose")
end

-----------------------------------------------------------------------------------初始化课程ui
function CourseControl:initCourseUI()
    --self["BrainsBtnHelp"]帮助按钮
    --奖励小花按钮
    --排行榜按钮
    --操作按钮
     self:getView():initUi()
     if self:courseMgr():getIdentity() == bbfd.COURSE_IDENTITY.TEACHER then
        printInfo("CourseControl:initCourseUI0")
        local tc = createGameControl("app.views.mainlineTask.teacher.TeacherControl")
        printInfo("CourseControl:initCourseUI1")
        tc:showInScene(self:uiMgr():getCurScene())
        printInfo("CourseControl:initCourseUI")
    end
end


----------------------------------------------------------------------------------课程基础信息初始化
--课程里的所有演员，所有属性字段管理
--交互与点击事件监听
function CourseControl:initCourseInfo()
   self.currExecEventIndex = 1
   self.totalExecEventNum =  self:getModel():getEventTotalNum()
   self.currEventVo = nil
   self.currEventOrder = nil
   self.currInteractIndex = 1
   self.updateAbled = false
  
   --self:getView():initUi() 部分ui和显示对象的呈现放在 View中处理
    
    --等待点击动画缓存
    self.handAniName = "gameCommonWaitTouch"
    if not display.getAnimationCache(self.handAniName) then --缓存动画
        local frames = display.newFrames("gameCommonWaitTouch%02d.png", 1, 26)
        display.setAnimationCache(self.handAniName, display.newAnimation(frames, 0.05))
    end

    --------------------------------------------------------------------------------
    --角色对话动画
    --------------------------------------------------------------------------------
    self.dbnode = {}
	self.bonesFile = {}
	self.armatureName = {}
	----------------------------------------------------------------
	--如果是单个文件名的， 做一些转换工作
	if type(self:getModel():getVo().bonesFile) == "string" then
		table.insert(self.bonesFile,self:getModel():getVo().bonesFile)
	else
		self.bonesFile = self:getModel():getVo().bonesFile
	end

	if type(self:getModel():getVo().armatureName) == "string" then
		table.insert(self.armatureName,self:getModel():getVo().armatureName)
	else
		self.armatureName = self:getModel():getVo().armatureName
	end

	if self["bonePos"] ~= nil then
		self["bonePos1"] = self["bonePos"]
	end

	if self["Panel_Bones"] ~= nil then
		self["Panel_Bones1"] = self["Panel_Bones"]
	end

	if self["Panel_Button"] ~= nil then
		self["Panel_Button1"] = self["Panel_Button"]
	end

	if self["WaitTouch"] ~= nil then
		self["WaitTouch1"] = self["WaitTouch"]
	end

	if self["btnWaitTouch"] ~= nil then
		self["btnWaitTouch1"] = self["btnWaitTouch"]
	end

    if self.bonesFile ~= nil then
		self:animMgr():loadDragonBonesFiles(self.bonesFile)
        for i=1,#self.bonesFile do
            printInfo("self.armatureName :"..i.." :"..self.armatureName[i])
            self.dbnode[i] = self:animMgr():getAnimation(self.armatureName[i])
            self.dbnode[i].armatureName = self.armatureName[i]
            self["Panel_Bones"..i]:addChild(self.dbnode[i])
            DisplayUtil:nodeEqualRatio(self.dbnode[i])
            self.dbnode[i]:setPosition(self["bonePos"..i]:getPositionX(),self["bonePos"..i]:getPositionY())
            self["dbnode"..i] = self.dbnode[i]
        end
    end

    for i=1,100 do
        if self["WaitTouch"..i] ~= nil then
            self["WaitTouch"..i]:playAnimationForever(display.getAnimationCache(self.handAniName))
        end
    end

     --点击执行
    for i=1,100 do
        if self["Panel_Button"..i] == nil then
            break
        end
        if self["Panel_Button"..i] ~= nil then
            self["Panel_Button"..i]:setVisible(false)
            DisplayUtil:nodeEqualRatio(self["Panel_Button"..i])
            if self["btnWaitTouch"..i] ~= nil then
                self["btnWaitTouch"..i]:setTag(i)
                self["btnWaitTouch"..i]:addTouchEventListener(handler(self,self.onClickExecEventHandle))
                --printInfo("btnWaitTouch"..i)
                --self["btnWaitTouch"..i]:setTouchEnabled()
                --dump()
            end
        end
    end

   --------------------------------------------------------------------------------
    --互动动画
    --------------------------------------------------------------------------------
   self:animMgr():loadDragonBonesFiles(self:getModel():getInteractFile())
   local armtb =  self:getModel():getInteractArm()
   self.dbInteract = {}  
   if self:getModel():getInteractFile() ~= nil then
        for i=1,#self:getModel():getInteractFile() do
           --printInfo(armtb[i])
           self.dbInteract[i] = self:animMgr():getAnimation(armtb[i])
           self["Panel_Interact"..i]:addChild(self.dbInteract[i])
            DisplayUtil:nodeEqualRatio(self.dbInteract[i])
           self.dbInteract[i]:setPosition(self["interactPos"..i]:getPositionX(),self["interactPos"..i]:getPositionY())
           self["dbInteract"..i] = self.dbInteract[i]
        end
   end

   --互动
    for i=1,100 do
        if self["interactButton"..i] ~= nil then
            self["interactButton"..i]:setTag(i)
            self["interactButton"..i]:addTouchEventListener(handler(self,self.onInteractTouchHandle))
        end
    end


	--------------------------------------------------------------------------------
    --说话动画
    --------------------------------------------------------------------------------
	local talkFile = self:getModel():getTalkFile()
	if talkFile ~= nil then
        self.talkNode = {}
		self:animMgr():loadDragonBonesFile(talkFile)

		local talkIsActive = self:getModel():getTalkIsActive()
		local talkArmature = self:getModel():getTalkArmature()
        for i=1,#talkIsActive do
            if talkIsActive[i] == true then
                self.talkNode[i] = {}
                self.talkNode[i][1] = self:animMgr():addAnimation(self.dbnode[i],talkArmature[1])
                self.talkNode[i][1]:getAnimation():play()

                self.talkNode[i][2] = self:animMgr():addAnimation(self.dbnode[i],talkArmature[2])
                self.talkNode[i][2]:getAnimation():play()
            end
        end
    end

   --播放背景音乐
   self:playDelayCommonGame()
   printInfo("CourseControl:initCourseInfo")
end

--课程实时处理更新设置可修改间隔时间
function CourseControl:initCourseUpdate()
   printInfo("initCourseUpdate")
   self:controlTimer():start(handler(self,self.onUpdate),0.1)
end

function CourseControl:playDelayCommonGame()
    if self:getModel():getDelayCommonGame() ~= nil then
        if self:courseMgr():getIdentity() ~= bbfd.COURSE_IDENTITY.TEACHER then
            self:controlTimer():runWithDelay(function()
                local soundid =  self:audioMgr():playBackgroundMusic("commonGame"..math.random(6)..".mp3",true)
                if PlayerData.bgMusicVolume ~= nil then
                   self:audioMgr():setMusicVolume(soundid,PlayerData.bgMusicVolume)
                end
            end,self:getModel():getDelayCommonGame()[2])
        end
    end
end

---------------------------------------------------------------------------实时处理事件
function CourseControl:onUpdate(dt)
 --printInfo("CourseControl:onUpdate")
    if self.updateAbled then
        if self.currEventVo ~= nil then
            if  self.currEventOrder ~= nil then
                if self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.LOADING_BAR or self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.MOVE_TO then
                    self.currEventOrder:execute(dt)
                end
            end
        end
    end
    
end

--------------------------------------------------------------------------交互事件
--简单交互动画处理
function CourseControl:onInteractTouchHandle(sender, state)
    if state == 2 then
        self:audioMgr():playEffect("commonBtn.mp3",false)
        self.currInteractIndex = sender:getTag()
        printInfo("CourseControl:onInteractTouchHandle:tag:"..self.currInteractIndex)
        --self.interactTag = tag
        -- self.otherEventStep = 0
        self:startUpInteractCourseEvent()
    end
end

--通过点击执行主事件
function CourseControl:onClickExecEventHandle( sender, state )
    -- body
    printInfo("onClickEvent ")
    if state == 2 then
         printInfo("onClickEvent!startUpOperateCourseEvent")
         local btntag = sender:getTag()
         self:startUpOperateCourseEvent(btntag)
    end
end

-------------------------------------------------------------------------------------课程事件

--启动课程里的主课程事件
function CourseControl:startUpCourseEvent()
    printInfo("CourseControl:startUpCourseEvent"..self.currExecEventIndex)
    self.currEventVo = self:getModel():getNewEventVo(self.currExecEventIndex)
    if self.currEventVo == nil then return end
    dump(self.currEventVo)
    if self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.SET_FILPPED then
        self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("BaseCourseEvent",self.currEventVo,self,self.dbInteract,self.dbnode)
    elseif self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.SET_VISIBLE then
        self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("BaseCourseEvent",self.currEventVo,self,self.dbInteract,self.dbnode)
    elseif self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.PLAY_OVER then
        self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("BaseCourseEvent",self.currEventVo,self,self.dbInteract,self.dbnode)
    elseif self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.SET_SCALE then
        self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("BaseCourseEvent",self.currEventVo,self,self.dbInteract,self.dbnode)
    elseif self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.SCALE_TO then
        self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("BaseCourseEvent",self.currEventVo,self,self.dbInteract,self.dbnode)
    elseif self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.SET_POSITION then
        self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("BaseCourseEvent",self.currEventVo,self,self.dbInteract,self.dbnode)
    elseif self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.SET_OPACITY then
        self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("BaseCourseEvent",self.currEventVo,self,self.dbInteract,self.dbnode)
    elseif self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.TITLE_EVENT then
        self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("PanelCourseEvent",self.currEventVo,self,self.dbInteract,self.dbnode)
    elseif self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.FADE_IN then
        self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("BaseCourseEvent",self.currEventVo,self,self.dbInteract,self.dbnode)
    elseif self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.TIME then
        self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("BaseCourseEvent",self.currEventVo,self,self.dbInteract,self.dbnode)
    elseif self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.CLICK then
        if self["Panel_Button"..self.currEventVo.click] ~= nil then
             self["Panel_Button"..self.currEventVo.click]:setVisible(true)
        end
        if self["WaitTouch"..self.currEventVo.click] ~= nil then
             self["WaitTouch"..self.currEventVo.click]:setVisible(true)
        end
         
    elseif self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.MOVE_TO then
        self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("BaseCourseEvent",self.currEventVo,self,self.dbInteract,self.dbnode)
    elseif self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.LOADING_BAR then
        self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("TimerCourseEvent",self.currEventVo,self)
        self.updateAbled = true
    elseif self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.MULTI_CLICK then
        self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("OperateCourseEvent",self.currEventVo,self)
	elseif self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.FADE_IN then
        self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("BaseCourseEvent",self.currEventVo,self,self.dbInteract,self.dbnode)
    elseif self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.FADE_OUT then
        self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("BaseCourseEvent",self.currEventVo,self,self.dbInteract,self.dbnode)
	elseif self.currEventVo.type == bbfd.COURSE_EVENT_ORDER.MOVE_BY then
        self.currEventOrder = bbfd.courseFactory:createCourseEventOrder("BaseCourseEvent",self.currEventVo,self,self.dbInteract,self.dbnode)
    end

    if self.currEventOrder ~= nil then
        self.currEventOrder:execute()
    end

end


--启动课程里交互课程事件
function CourseControl:startUpInteractCourseEvent()
    local tempEventVo = self:getModel():getInteractEventVo(self.currInteractIndex)
    --dump(currEventVo)
    if tempEventVo == nil then return end
    local interactEventOrder = nil
    --printInfo(currEventVo.type)
    interactEventOrder = bbfd.courseFactory:createCourseEventOrder("InteractCourseEvent",tempEventVo,self,self.dbInteract)

    if interactEventOrder ~= nil then
        interactEventOrder:execute()
    end
end

--启动课程里点击执行课程事件
function CourseControl:startUpOperateCourseEvent(tagindx)
   local tempEventVo = self:getModel():getNewEventVo(self.currExecEventIndex)
   if tempEventVo == nil then return end
    if tempEventVo.type == bbfd.COURSE_EVENT_ORDER.CLICK then
        self.currEventOrder =  bbfd.courseFactory:createCourseEventOrder("OperateCourseEvent",tempEventVo,self)
        if self.currEventOrder ~= nil then
            self.currEventOrder:execute()
        end
    elseif tempEventVo.type == bbfd.COURSE_EVENT_ORDER.MULTI_CLICK then
        if self.currEventOrder ~= nil then
            self.currEventOrder:startUpOperateCourseEvent(tagindx)
        end
    end

  

end

--课程的所有事件处理
function CourseControl:couseEventFinishHandle(coursename)
     printInfo("CourseControl:couseEventFinishHandle:abc:"..self:getCourseName().."//"..self.currExecEventIndex)
    if self:getCourseName() == coursename then
        printInfo("CourseControl:couseEventFinishHandle".. self.currExecEventIndex.."//"..self.totalExecEventNum)
        if self.currEventOrder ~= nil then
            self.currExecEventIndex = self.currExecEventIndex + 1
            self.currEventOrder:goDispose()
            self.currEventOrder = nil
            self.updateAbled = false
             self:initPanelButtons()
        end
       
        if self.currExecEventIndex <= self.totalExecEventNum then
            self:startUpCourseEvent()
        else 
            --self:evtMgr():Brocast(bbfd.COURSE_EVENT.FRAGMENT_FINISH)
            printInfo("bbfd.COURSE_EVENT.FRAGMENT_FINISH")
            --self:goDispose()
            self:courseMgr():playNextCourseNode()
            --
        end
    end

end

----------------------------------------------------------------------属性

function CourseControl:setCourseName(nm)
    self.courseName_ = nm
end

function CourseControl:getCourseName()
   return self.courseName_
end

--初始化点击交互动画的隐藏
function CourseControl:initPanelButtons()
        for i=1,20 do
            if self["Panel_Button"..i] ~= nil then
                self["Panel_Button"..i]:setVisible(false)
            end
        end
end

function CourseControl:courseMgr()
    return bbfd.courseMgr
end

--endregion
return CourseControl