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
function DownManager:AsyncDownAssets(callback,...)
   local loadList = {...}
   local loadSize = table.nums(loadList)

   if loadSize<=0 or callback==nil then
       error(" DownManager:AsyncDownAssets - no callback or no file", 0)
   end
   
   if loadSize == 1 and type(loadList[1]) == "table" then
      loadList = loadList[1]
      loadSize = table.nums(loadList)
   end

  -- dump(loadList,"loadList")
   local loadingArray = {"","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",}

   if loadSize > 40 then
       loadSize = 40
       printInfo("DownManager:AsyncDownAssets-预加载尺寸超出！")
   end

   for i=1,loadSize do
    	loadingArray[i] = loadList[i]
   end
    --dump(loadSize,"loadSize")
    --dump(loadingArray,"loadingArray")
   self.asyncCallBack = callback
   --dump(self.asyncCallBack,"asyncCallBack")

   threadLoadAssets(function(step)
        printInfo("DownManager:AsyncDownAssets step:"..step.." asset:"..loadingArray[step])
        if step >= loadSize then
        	--结束时返回
            if self.asyncCallBack == nil then
                bbfd.evtMgr():getInstance():Brocast(bbfd.EVENT_ASYNC_DONW_FINISH)
            else 
                self.asyncCallBack()
            end
    		
        end
    end,loadSize,loadingArray[1],loadingArray[2],loadingArray[3],loadingArray[4],loadingArray[5],loadingArray[6],loadingArray[7],
    loadingArray[8],loadingArray[9],loadingArray[10],loadingArray[11],loadingArray[12],loadingArray[13],loadingArray[14],loadingArray[15],
    loadingArray[16],loadingArray[17],loadingArray[18],loadingArray[19],loadingArray[20],loadingArray[21],loadingArray[22],loadingArray[23],loadingArray[24],loadingArray[25],
    loadingArray[26],loadingArray[27],loadingArray[28],loadingArray[29],loadingArray[30],loadingArray[31],loadingArray[32],loadingArray[33],loadingArray[34],loadingArray[35],
    loadingArray[36],loadingArray[37],loadingArray[38],loadingArray[39],loadingArray[40])

end

--endregion
return DownManager