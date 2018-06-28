--region EventManager.lua
--Date
--此文件由[BabeLua]插件自动生成
--事件管理单例类
--使用例子：
--EventManager:getInstance().AddListener(bbyd.EVENT_START,testHandler);
--  function testHandler(args)
--  end
require "bbfd.constants.EventConstant"
local EventLib = require("bbfd.core.eventlib");
local EventManager = class("EventManager");
EventManager.instance = nil;
EventManager.events = {};

function EventManager:getInstance()
   if not EventManager.instance then
      EventManager.instance = EventManager:create()
   end
   return EventManager.instance
end

--添加事件监听
function EventManager:AddListener(event,handle)
    if not event or type(event) ~= "string" then
       error("event parameter in AddListener function has to be string,"..type(event).."not right!")
    end

    if not handle or type(handle) ~= "function" then
       error("handle parameter in AddListner function has to be function,"..type(handle).."not right!")
    end
    
    if not EventManager.events[event] then
        EventManager.events[event] =  EventLib:new(event)
       -- printInfo("EventManager:AddListener"..event)
    end

    EventManager.events[event]:connect(handle)
end

--移除事件监听
--移除handle时注意使用  
--处理函数临时缓存起来 self.currStartPlayHandler = handler(self,self.startPlayHander)
function EventManager:removeListener(event,handle)
    if not EventManager.events[event] then
        --error("remove"..event.."has no event")
    else
        --printInfo("removeListener:"..event)
        EventManager.events[event]:disconnect(handle)
    end

end

--广播事件
function EventManager:Brocast(event,...)
    if not EventManager.events[event] then
        --error("Brocast"..event.."has no event");
    else
       -- printInfo("EventManager:Brocast"..event)
        EventManager.events[event]:fire(...);
    end
end

function EventManager:getHandleCount(event)
    if not EventManager.events[event] then
        error("remove"..event.."has no event");
    else
        --printInfo(event.."事件处理计数:"..EventManager.events[event]:ConnectionCount())
    end
end

return EventManager
--endregion
