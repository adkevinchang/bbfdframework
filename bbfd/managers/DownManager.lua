--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
--kevin
--控制整个游戏的下载节奏  

local DownManager = class("DownManager");
DownManager.instance = nil;

function DownManager:getInstance()
   if not DownManager.instance then
      DownManager.instance = DownManager:create();
   end
   return DownManager.instance;
end

--[[
异步下载
callback:异步加载完后回调
size:加载文件多少
...：文件名
]]
function DownManager:AsyncDownAssets(callback,size,...)
   if size<=0 or callback==nil then
       error(" DownManager:AsyncDownAssets - no callback or no file", 0)
   end
   local loadingArray = {...}
   self.asyncCallBack = callback
   threadLoadAssets(function( step )
        printInfo("threadLoadAssets step:"..step.." asset:"..loadingArray[step])
        if step >= size then
        	--结束时返回
    		self.asyncCallBack()
            bbfd.evtMgr():getInstance():Brocast(bbfd.EVENT_ASYNC_DONW_FINISH)
        end
    end,size,...)
end

--endregion
return DownManager