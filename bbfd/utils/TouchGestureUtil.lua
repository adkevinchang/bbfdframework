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
TouchGestureUtil.MAX_POS_NUM = 4
--计算圆手势最多点数 数字越大，画的圆越标准
TouchGestureUtil.CIRCLE_POS_NUM = 8

TouchGestureUtil.RECORD_MAX_POS_NUM = 40

--上下左右
TouchGestureUtil.DIFFICULTY_LEVEL = 0.8


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
   
    --测试
   -- loggerGameLog("手势路径:-------------------------------")
    for i,val in ipairs(paths)do
      -- loggerGameLog("手势路径:"..val.x.."//"..val.y)
    end
    --loggerGameLog("手势路径:-------------------------------")

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

    --loggerGameLog("手势路径:pos1--"..pos1.x.."//"..pos1.y.."//"..r1.."//"..r2)
    --loggerGameLog("手势路径:pos2--"..pos2.x.."//"..pos2.y.."//"..currr1.."//"..currr2)
    --loggerGameLog("手势路径:pos3--"..pos3.x.."//"..pos3.y.."//")
    
    --角度差正负40度方向范围

    if r1 >= -115 and r1 <= -75 then
        if r2 >= -115 and r2 <= -75 then
             return TouchGestureUtil.Type.UP
        end
        if TouchGestureUtil.MAX_POS_NUM <= 5 then
            return TouchGestureUtil.Type.UP
        end 
    end

    if r1 >= 75 and r1 <= 115 then
        if r2 >= 75 and r2 <= 115 then
             return TouchGestureUtil.Type.DOWN
        end
        if TouchGestureUtil.MAX_POS_NUM <= 5 then
            return TouchGestureUtil.Type.DOWN
        end 
    end

    if currr1 >= 140 and currr1 <= 180 then
        if currr2 >= 140 and currr2 <= 180 then
             return TouchGestureUtil.Type.RIGHT
        end
        if TouchGestureUtil.MAX_POS_NUM <= 5 then
            return TouchGestureUtil.Type.RIGHT
        end 
    end

    if currr1 >= 0 and currr1 <= 40 then
        if currr2 >= 0 and currr2 <= 40 then
             return TouchGestureUtil.Type.LEFT
        end
        if TouchGestureUtil.MAX_POS_NUM <= 5 then
             return TouchGestureUtil.Type.LEFT
        end 
    end
    return TouchGestureUtil.Type.DEFAULT
end

--检查指定方向是否包含该方向度数
function TouchGestureUtil:checkTouchGestureByDire(direInfo,paths)

   local totallen = table.nums(paths)*TouchGestureUtil.DIFFICULTY_LEVEL
   if direInfo == TouchGestureUtil.Type.UP then 
        local currvalue  = 0
        for i,val in ipairs(paths)do
           if paths[i+1] and paths[i] then
               if paths[i+1].y > paths[i].y then
                  currvalue = currvalue + 1
               end
           end
        end
        if currvalue >= totallen then
             return true
        end
   elseif direInfo == TouchGestureUtil.Type.DOWN then
        local currvalue  = 0
        for i,val in ipairs(paths)do
           if paths[i+1] and paths[i] then
               if paths[i+1].y < paths[i].y then
                  currvalue = currvalue + 1
               end
           end
        end
        if currvalue >= totallen then
             return true
        end
   elseif direInfo == TouchGestureUtil.Type.LEFT then
        local currvalue  = 0
        for i,val in ipairs(paths)do
           if paths[i+1] and paths[i] then
               if paths[i+1].x < paths[i].x then
                  currvalue = currvalue + 1
               end
           end
        end
        if currvalue >= totallen then
             return true
        end
   elseif direInfo == TouchGestureUtil.Type.RIGHT then
        local currvalue  = 0
        for i,val in ipairs(paths)do
           if paths[i+1] and paths[i] then
               if paths[i+1].x > paths[i].x then
                  currvalue = currvalue + 1
               end
           end
        end
        if currvalue >= totallen then
             return true
        end
   end

   return false
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