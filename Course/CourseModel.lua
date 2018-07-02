--region *.lua
--Date
--课程基础模块的数据处理类
--kevin
local CourseModel = class("CourseModel",cc.load("mvc").ModelBase)

function CourseModel:onCreate()
   printInfo("CourseModel:onCreate"..self.bbfdId)
end

function CourseModel:goDispose()
     CourseModel.super.goDispose(self)
     printInfo("CourseModel:goDispose")
end

function CourseModel:getNewEventVo(idx)
   if self:getVo() and self:getVo()["event"] then
      local eventtb = self:getVo()["event"]
      if idx <= table.nums(eventtb) then
          return eventtb[idx]
      end
   end
   return nil
end

function CourseModel:getEventTotalNum()
  if self:getVo() and self:getVo()["event"] then
      local eventtb = self:getVo()["event"]
      if eventtb then
          return table.nums(eventtb)
      end
   end
   return 0
end

function CourseModel:getInteractEventVo(idx)
   if self:getVo() and self:getVo()["interactEvent"] then
      local eventtb = self:getVo()["interactEvent"]
      if idx <= table.nums(eventtb) then
          return eventtb[idx]
      end
   end
   return nil
end

function CourseModel:getInteractFile()
    if self:getVo() == nil then return nil end
    return self:getVo()["interactFile"]
end

function CourseModel:getInteractArm()
    if self:getVo() == nil then return nil end
    return self:getVo()["interactArm"]
end



function CourseModel:getDelayCommonGame()
    if self:getVo() == nil then return nil end
    return self:getVo()["delayCommonGame"]
end

--对话
function CourseModel:getTalkFile()
	if self:getVo() == nil then return nil end
	return self:getVo()["talkFile"]
end

function CourseModel:getTalkArmature()
	if self:getVo() == nil then return nil end
	return self:getVo()["talkArmature"]
end

function CourseModel:getTalkIsActive()
	if self:getVo() == nil then return nil end
	return self:getVo()["talkIsActive"]
end

--地图名字
function CourseModel:getMapName()
	if self:getVo() == nil then return nil end
	return self:getVo()["mapName"]
end

--endregion
return CourseModel