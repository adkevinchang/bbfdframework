--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local StringUtil = {}

--返回1说明有更新，返回0则没有更新
function StringUtil:checkVersion(oldv,newv)
   local oldmap = string.split(oldv,".")
   local newmap = string.split(newv,".")
   for i=1,table.nums(oldmap) do
        if tonumber(newmap[i]) > tonumber(oldmap[i]) then
            return 1
        end
   end
   return 0
end
--endregion
return StringUtil