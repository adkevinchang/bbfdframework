--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local CryptoUtil = {}

--[[
classno:编辑唯一码。11位正整数数字 
返回密钥  26+26+24
]]
function CryptoUtil:encryptBbfdSn(classno)
   local sntool = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!#$%&()*+-:;<=>?@[]_{|}~"
   --原数加20121231
   --原数加加倍生成本数
   --倒序本数取值 如果2位大于76，否则取1位
   local yuannum = classno + 20121231
   local bennum = yuannum * 2
   local benstr = tostring(bennum)
   local benlen = string.len(benstr)

   local currindex = 1
   for i=1,benlen do
   		local currstrnum = getCurrPosNum(benstr,currindex,2)
   end



end

function CryptoUtil:getCurrPosNum(contentstr,pos,len)

	return -1
end

--[[
classsn:密钥（由字符和符号构成）
返回班级唯一码
]]
function CryptoUtil:decryptBbfdSn(classsn)
   local sntool = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!#$%&()*+-:;<=>?@[]_{|}~"
   --取值还原本数
   --本数倒序原数
   --原数减倍
   --原数减20121231
   
end

--endregion
return CryptoUtil