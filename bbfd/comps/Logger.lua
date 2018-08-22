--region Logger.lua
--Date 2018/4/11
--此文件由[BabeLua]插件自动生成
--kevin


--endregion
--region 日志操作性能查询

--打印游戏中的日志
--本地手机可查日志使用前，请initLocalLogByC() 创建日志文件
function loggerGameLog(fmt, ...)
    local t = {
        "[",
        string.upper(tostring("GL-INFO")),
        "] ",
        string.format(tostring(fmt), ...)
    }
    local file = io.open(getDeviceLocalDir().."/GameLog.log", "a+")  
    file:write("\n"..table.concat(t).."\n")  
    file:close()  
	
    printInfo(fmt)
end

--用来输出渲染树，检测内存泄漏  
function loggerNodeTree()  
    if DEBUG < 1 then
        return 
    end
    printInfo("打印当前场景的渲染树 s="..os.time())
    local file = io.open(getDeviceLocalDir().."/NodeTree.txt", "w")  
    file:write("\n用来输出渲染树，检测内存泄漏\n")  
    file:write("\n======================= Render Node Tree Begin =======================\n")  
    searchNodeTree(display.getRunningScene(), 1, file)  
    collectgarbage("collect")
    printInfo("当前内存:"..collectgarbage("count").."当前时间:"..os.time())
    file:write("当前内存:"..collectgarbage("count").."当前时间:"..os.time())
    file:write("\n======================= Render Node Tree End =========================\n")  
  
    file:close()  
end  
  
function searchNodeTree(node, level, file) 
    --[-[
    for index = 1, #node:getChildren() do  
        local nextNode = node:getChildren()[index]  
        
        --printInfo(nextNode:getName())
        --printInfo(nextNode:getChildren())
        --printInfo(nextNode:getChildrenCount())
        --printInfo(type(nextNode))
        --printInfo("===============================")
        if "userdata" == type(nextNode) and nil ~= nextNode:getChildren() and 0 ~= nextNode:getChildrenCount() then  
            writeNode(level, tostring(nextNode:getName()), file, true)  
            searchNodeTree(nextNode, level + 1, file)  
        else  
            writeNode(level, tostring(nextNode:getName()), file, false)  
        end  
    end  --]]

end  
  
function writeNode(level, nodeName, file, hasChild)  
    local str = ""  
  
    for i = 1, level do  
        str = "    " .. str  
    end  
  
    if true == hasChild then  
        str = str .. "+"  
    elseif false == hasChild then  
        str = str .. "-"  
    end  
  
    str = table.concat({str, "[", level, "]", nodeName, "\n"})  
    file:write(str)  
end  

--更细化的日志输出
function printTT(content, ...)
    local tab = 0
    local out_list = {}

    local function printk(value, key, tab)
        if key == nil then
            return
        end

        if type(key) ~= "number" then
            key = tostring(key)
        else
            key = string.format("[%d]", key)
        end

        if type(value) == "table" then
            if key ~= nil then
                table.insert(out_list, tab .. key .. " =")
            end

            table.insert(out_list, tab .. "{")

            for k, v in pairs(value) do
                printk(v, k, tab .. "|  ")
            end

            table.insert(out_list, tab .. "},")
        else
            local content

            if type(value) == "nil" or value == "^&nil" then
                value = "nil"
            elseif type(value) == "string" then
                value = string.format("\"%s\"", tostring(value))
            else
                value = tostring(value)
            end
            content = string.format("%s%s = %s,", tab, key, value)
            table.insert(out_list, tostring(content))
        end
    end


    local value = type(content) == "string" and string.format(content, ...) or content

    local key = os.date("[\"%X\"]", os.time())
    printk(value, key, "")

    local out_str = table.concat(out_list, "\n")
    print(out_str .. "\n")

    -- local logFileName = os.date("print_tab_%Y_%m_%d.log", os.time())
    local logFileName = getDeviceLocalDir().."/GameLog.log"
    local file = assert(io.open(logFileName, "a+"))
    file:write(out_str .. "\n")
    file:close()
end

--打印小量table
function loggerd(...)
    printTT(...)
end

function loggerString(...)
    local arg = {...}
    local formatString = ""
    for i = 1, #arg do 
        formatString = formatString .. "%s   "
        arg[i] = tostring(arg[i])
    end
    printTT(formatString, unpack(arg))
end

--打印堆栈Stack
function loggerdw(content)
    printTT(debug.traceback(content))
end

local function dump_value_(v)
    if type(v) == "string" then
        v = "\"" .. v .. "\""
    end
    return tostring(v)
end

--打印大量table
function loggerDump(value, desciption, nesting)
    if type(nesting) ~= "number" then nesting = 3 end

    local lookupTable = {}
    local result = {}

    local traceback = string.split(debug.traceback("", 2), "\n")
    print("dump from: " .. string.trim(traceback[3]))

    local function dump_(value, desciption, indent, nest, keylen)
        desciption = desciption or "<var>"
        local spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(dump_value_(desciption)))
        end
        if type(value) ~= "table" then
            result[#result +1 ] = string.format("%s%s%s = %s", indent, dump_value_(desciption), spc, dump_value_(value))
        elseif lookupTable[tostring(value)] then
            result[#result +1 ] = string.format("%s%s%s = *REF*", indent, dump_value_(desciption), spc)
        else
            lookupTable[tostring(value)] = true
            if nest > nesting then
                result[#result +1 ] = string.format("%s%s = *MAX NESTING*", indent, dump_value_(desciption))
            else
                result[#result +1 ] = string.format("%s%s = {", indent, dump_value_(desciption))
                local indent2 = indent.."    "
                local keys = {}
                local keylen = 0
                local values = {}
                for k, v in pairs(value) do
                    keys[#keys + 1] = k
                    local vk = dump_value_(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then keylen = vkl end
                    values[k] = v
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for i, k in ipairs(keys) do
                    dump_(values[k], k, indent2, nest + 1, keylen)
                end
                result[#result +1] = string.format("%s}", indent)
            end
        end
    end
    dump_(value, desciption, "- ", 1)

    local logFileName = getDeviceLocalDir().."/GameLog.log"
    local file = assert(io.open(logFileName, "a+"))
    for i, line in ipairs(result) do
        print(line)
        file:write(line .. "\n")
    end
    file:close()
end

--获取应用所在设备本地文件夹
function getDeviceLocalDir()
    local localAppName = "ddtcyj_teacher"
    if device.platform == "windows" then
        return "./"..localAppName
    elseif device.platform == "android" then
        return "/mnt/sdcard/"..localAppName
    elseif device.platform == "ios" then
        return "/ducoment/"..localAppName
    else
        return ""
    end
end
--endregion