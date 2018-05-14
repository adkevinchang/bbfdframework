--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local TouchGestureUtil = {}

TouchGestureUtil.Type = 
{
    DEFAULT = 1000,
    UP      = 1001,
    DOWN    = 1002,
    LEFT    = 1003,
    RIGHT   = 1004,
    CIRCLE  = 1005,
}
--计算手势最多点数
TouchGestureUtil.MAX_POS_NUM = 8
--计算圆手势最多点数 数字越大，画的圆越标准
TouchGestureUtil.CIRCLE_POS_NUM = 8

TouchGestureUtil.RECORD_MAX_POS_NUM = 40

--endregion

--paths 全路径点point
function TouchGestureUtil:checkTouchGesture(paths)
    local pathslen  = table.nums(paths)
    if pathslen <3 then
       return TouchGestureUtil.Type.DEFAULT
    end
    --dump(paths)
    --判断圆
    local prer1 = 0
    local greaterNum = 0
    local lessNum = 0

    for i,val in ipairs(paths)do
        local r1 = TouchGestureUtil:getAngleByPos(paths[i],paths[i+1]);
        if r1 ~= nil then
            if r1 >= prer1 then
                greaterNum = greaterNum + 1
                if greaterNum >= TouchGestureUtil.CIRCLE_POS_NUM then
                    return TouchGestureUtil.Type.CIRCLE
                end
                lessNum = 0
            elseif r1 <= prer1 then
                lessNum = lessNum + 1
                if lessNum >= TouchGestureUtil.CIRCLE_POS_NUM then
                    return TouchGestureUtil.Type.CIRCLE
                end
                greaterNum = 0
            end
            prer1 = r1
            --printInfo("angle:"..r1)
        end
    end
    --printInfo("greaterNum:"..greaterNum)
   -- printInfo("lessNum:"..lessNum)
    

    --判断方向
    if pathslen > TouchGestureUtil.MAX_POS_NUM then
        pathslen = TouchGestureUtil.MAX_POS_NUM
    end
    local centernum = math.ceil(pathslen/2)
    local pos1,pos2,pos3 = paths[1],paths[centernum],paths[pathslen]
    --检查2个点夹角
    local r1 = TouchGestureUtil:getAngleByPos(pos2,pos1);
    local r2 = TouchGestureUtil:getAngleByPos(pos3,pos2);
    local currr1 = math.abs(r1)
    local currr2 = math.abs(r2)

    if r1 >= -105 and r1 <= -75 then
        if r2 >= -105 and r2 <= -75 then
             return TouchGestureUtil.Type.UP
        end
    end

    if r1 >= 75 and r1 <= 105 then
        if r2 >= 75 and r2 <= 105 then
             return TouchGestureUtil.Type.DOWN
        end
    end

    if currr1 >= 165 and currr1 <= 180 then
        if currr2 >= 165 and currr2 <= 180 then
             return TouchGestureUtil.Type.RIGHT
        end
    end

    if currr1 >= 0 and currr1 <= 15 then
        if currr2 >= 0 and currr2 <= 15 then
             return TouchGestureUtil.Type.LEFT
        end
    end
    return TouchGestureUtil.Type.DEFAULT
end

--返回角度-180  ---  180
function TouchGestureUtil:getAngleByPos(p1,p2)
   if p1 == nil or p2 == nil then
      return nil
   end
   local p = {}
   p.x = p2.x - p1.x
   p.y = p2.y - p1.y
   local r  = math.atan2(p.y,p.x)*180/math.pi
   return r
end

return TouchGestureUtil