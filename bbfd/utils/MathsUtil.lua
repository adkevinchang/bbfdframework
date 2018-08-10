--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local MathsUtil = {}

function MathsUtil:getDistancePoints(x1,y1,x2,y2)
    return math.sqrt(math.pow((y2-y1),2)+math.pow((x2-x1),2))
end

--endregion
return MathsUtil