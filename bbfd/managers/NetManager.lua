--region NetManager.lua
--Date
--此文件由[BabeLua]插件自动生成
require "bbfd.constants.NetConstant"

local NetManager = class("NetManager");
NetManager.instance = nil;


function NetManager:getInstance()
   if not NetManager.instance then
      NetManager.instance = NetManager:create();
   end
   return NetManager.instance;
end

--发送http请求
function NetManager:sendHttp(info,params,outputFun,mode)
    if type(outputFun) ~= "function" then
        outputFun = function() end
    end


    -- body
    local xhr = cc.XMLHttpRequest:new()-- 新建一个XMLHttpRequest对象
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON  -- 返回数据为字节流
    -- utils.socketAddress = "http://192.168.1.151:81/"
    local socketAddress = bbfd.NET_SOCKET_ADDRESS;
    -- print("socketAddress--------------",socketAddress)
    if mode == "task" then
        socketAddress = bbfd.NET_SUB_ADDRESS
    elseif mode == "sub" then
        socketAddress = bbfd.NET_GET_ADDRESS
    elseif mode == "pay" then
        -- utils.payAddress = "http://192.168.1.151:82/"
        socketAddress = bbfd.NET_PAY_ADDRESS
    end

    xhr:open("POST", socketAddress .. info) -- 打开Socket

    -- dump(socketAddress..info,"http info")

    -- 状态改变时调用
    local function onReadyStateChange()
        local response = xhr.response
        -- 获得响应数据

        if response ~= nil and string.len(response) > 0 then
            local output = json.decode(response, 1)
            -- 解析json数据
            if output["result"] ~= nil then
                local output2 = json.decode(output["result"], 1)
                -- 解析json数据
                outputFun(output2)
            else
                outputFun(output)
            end
        else
            outputFun(nil)
        end
    end

    -- 注册脚本方法回调
    xhr:registerScriptHandler(onReadyStateChange)

    params["app_name"] = "ddtc"

    local postData = ""
    for i, v in pairs(params) do
        if postData == "" then
            postData = i .. "=" .. v
        else
            postData = postData .. "&" .. i .. "=" .. v
        end
    end

    -- dump(postData,"http postData")

    xhr:send(postData)-- 发送

    -- if utils.hallScene then
    --   utils.hallScene.netText:setVisible(true)
    --   utils.hallScene.netText:setString(info)
    -- end
end

--发起payHTTP请求
function NetManager:sendPayHttp(info,params,outputFun,dataType)
    if type(outputFun) ~= "function" then
      outputFun = function()end;
    end

  -- body
    local xhr = cc.XMLHttpRequest:new()-- 新建一个XMLHttpRequest对象
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON  --返回数据为字节流
    xhr:open("POST", bbfd.NET_PAY_ADDRESS..info) -- 打开Socket
    -- xhr:open("POST", "http://192.168.1.151"..info) -- 打开Socket
    -- xhr:open("POST", "http://192.168.1.151:82/"..info) -- 打开Socket

    dump(bbfd.NET_PAY_ADDRESS..info,">>>>>>>>>>>支付结果")
    -- 状态改变时调用
    local function onReadyStateChange()
      local response   = xhr.response -- 获得响应数据  
      if response ~= nil then      
        local output = json.decode(response,1) -- 解析json数据
        if dataType == 1 then
            outputFun(output)
        else
            local output2 = json.decode(output["result"],1) -- 解析json数据
            outputFun(output2)
        end
      else
        outputFun(nil)
      end
    end

    -- 注册脚本方法回调
    xhr:registerScriptHandler(onReadyStateChange)

    local postData = ""
    for i,v in pairs(params) do
      if postData == "" then
        postData = i.."="..v
      else
        postData = postData.."&"..i.."="..v
      end
    end


    -- dump(postData,"http postData")

    xhr:send(postData)-- 发送
end

--region caosh

--发送http post请求
--url_str   URL
--params_tbl  要提交的参数
--callback_func  收到返回数据时的回调函数
function NetManager:sendHttpPost(url_str, params_tbl, callback_func)
	local xhr = cc.XMLHttpRequest:new() --新建一个XMLHttpRequest对象
	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON  --返回数据为字节流
	xhr:open("POST", url_str) 
	local function onReceived()
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
	        local response = json.decode(xhr.response) --获得响应数据
			dump(response,"post响应数据")
	        if callback_func~=nil then
		        callback_func(response)
	        end
        end
        xhr:unregisterScriptHandler()
	end
	xhr:registerScriptHandler(onReceived) --注册脚本方法回调
	xhr:send(json.encode(params_tbl))  --发送
end

--发送http get请求
--url_str   URL
--callback_func  收到返回数据时的回调函数
function NetManager:sendHttpGet(url_str, callback_func)
	local xhr = cc.XMLHttpRequest:new() --新建一个XMLHttpRequest对象
	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON  --返回数据为字节流
	xhr:open("GET", url_str) 
	local function onReceived()
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
	        local response = json.decode(xhr.response) --获得响应数据 
			dump(response,"get响应数据")
	        if callback_func~=nil then
		        callback_func(response)
	        end
        end
        xhr:unregisterScriptHandler()
	end
	xhr:registerScriptHandler(onReceived) --注册脚本方法回调
	xhr:send()  --发送
end

--endregion

return NetManager

--endregion
