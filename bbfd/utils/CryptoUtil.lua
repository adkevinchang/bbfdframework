--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local CryptoUtil = {}

--[[
return:编辑唯一码。11位不重复正整数数字 
]]
function CryptoUtil:getRandomNo()
    return 31273847291
end

--[[
classno:编辑唯一码。11位正整数数字 
返回密钥  26+26+24
]]

function CryptoUtil:encryptBbfdSn(classno)
   local sntool = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!#$%&()*+-:;=?@[]_{|}~"
   --原数加20121231
   --原数加加倍生成本数
   --倒序本数取值 如果2位大于73，否则取1位
   local yuannum = classno + 20121231
   --printInfo("原数:"..tostring(yuannum))
   local bennum = yuannum * 2
   local benstr = tostring(bennum)
   local benlen = string.len(benstr)
   --printInfo("本数:"..benstr)
   --printInfo("本数长度:"..tostring(benlen))
   local currindex = benlen
   local currstrnum = ""
   local snstr = ""
   local sntable = {}
   for i=1,benlen do
   		currstrnum,currindex = self:getCurrPosNum(benstr,currindex)
       printInfo(currstrnum.."//"..currindex)
        if currindex <= 0 then
            if currstrnum >= 0 then
                    local resultstr = string.sub(sntool,currstrnum+1,currstrnum+1)
                    dump(resultstr)
                    if resultstr ~= nil then
                        printInfo("resultstr"..resultstr)
                        table.insert(sntable,resultstr)
                    end
            end
            table.concat(sntable)
            for i,v in ipairs(sntable) do
               snstr = snstr..v
            end
            return snstr
        else
            if currstrnum >= 0 then
                local resultstr = string.sub(sntool,currstrnum+1,currstrnum+1)
                dump(resultstr)
                if resultstr ~= nil then
                    printInfo("resultstr"..resultstr)
                    table.insert(sntable,resultstr)
                end
            end
            table.concat(sntable)
        end
   end
   return snstr
end


--[[
contentstr:本数字符
pos:数字位置
返回
subnum  当前某段数字
currpos 当前位置
]]

function CryptoUtil:getCurrPosNum(contentstr,pos)
    local substr = string.sub(contentstr,pos-1,pos)
    local currpos = pos - 2
    printInfo("substr:"..substr)
    local subnum = tonumber(substr)
    if subnum == 0 and string.len(substr) == 2 then
        substr = string.sub(contentstr,pos,pos)
        currpos = pos - 1
        subnum = tonumber(substr)
    else
        if subnum > 73 then
            substr = string.sub(contentstr,pos,pos)
            currpos = pos - 1
            subnum = tonumber(substr)
        end
    end
    if string.len(substr) <= 0 then
        subnum = -1
    end
    printInfo("substr2:"..substr)
	return subnum,currpos
end

--[[
classsn:密钥（由字符和符号构成）
yuannum:班级唯一码
]]
function CryptoUtil:decryptBbfdSn(classsn)
   dump(classsn)
   local sntool = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!#$%&()*+-:;=?@[]_{|}~"
   local snlen = string.len(classsn)
   --printInfo(classsn)
   local bennum = 0
   local benstr = ""
   --取值还原本数
   for i=1,snlen do
      local snsubstr= string.sub(classsn,i,i)
      local snindex = string.find(sntool,snsubstr)
      printInfo(snsubstr.."//"..snindex)
      benstr = tostring(snindex-1)..benstr
      printInfo(benstr)
   end
  
   bennum = tonumber(benstr)
   printInfo(bennum)
   
   bennum = bennum/2
   local yuannum = bennum - 20121231
   printInfo(bennum)
   --本数倒序原数
   --原数减倍
   --原数减20121231
   return yuannum
end

--endregion
return CryptoUtil