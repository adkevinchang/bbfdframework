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

function StringUtil.widthSingle(inputstr)
    -- 计算字符串宽度
    -- 可以计算出字符宽度，用于显示使用
   local lenInByte = #inputstr
   local width = 0
   local i = 1
   while (i<=lenInByte) 
    do
        local curByte = string.byte(inputstr, i)
        local byteCount = 1;
        if curByte>0 and curByte<=127 then
            byteCount = 1                                           --1字节字符
        elseif curByte>=192 and curByte<223 then
            byteCount = 2                                           --双字节字符
        elseif curByte>=224 and curByte<239 then
            byteCount = 3                                           --汉字
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4                                           --4字节字符
        end

        local char = string.sub(inputstr, i, i+byteCount-1)
        --print(char)                                                         

        i = i + byteCount                                 -- 重置下一字节的索引
        width = width + 1                                 -- 字符的个数（长度）
    end
    return width
end

function StringUtil.utf8len( str )
    local len = 0
    local currentIndex = 1
    while currentIndex <= #str do
        local char = string.byte(str,currentIndex)
        currentIndex = currentIndex + StringUtil.chsize(char)
        len = len + 1
    end
    return len
end

function StringUtil.chsize(char)
    if not char then
        return 0
    elseif char > 240 then
        return 4
    elseif char > 225 then
        return 3
    elseif char > 192 then
        return 2
    else
        return 1
    end    
end

---------------------

function StringUtil.utf8sub(str,startChar,numChars)
   local startIndex = 1
   while startChar > 0 do
       local char = string.byte(str,startIndex)
       startIndex = startIndex + StringUtil.chsize(char)
       startChar = startChar - 1
   end
   --print("utf8sub:"..startIndex)
   local currentIndex = startIndex

   local endIndex = 1;
   while endIndex <= numChars and currentIndex <= #str do
       local char = string.byte(str,currentIndex)
       currentIndex = currentIndex + StringUtil.chsize(char)
       endIndex = endIndex + 1
   end
    --print("utf8sub:"..startIndex)
   -- print("utf8sub:"..currentIndex)
   return str:sub(startIndex,currentIndex - 1)
end

--endregion
return StringUtil