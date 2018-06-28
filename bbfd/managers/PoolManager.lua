--region *.lua
--Date2018/4/26
--此文件由[BabeLua]插件自动生成
--kevin

local PoolManager = class("PoolManager");
PoolManager.instance = nil;
PoolManager.pmap = {};

function PoolManager:getInstance()
   if not PoolManager.instance then
      PoolManager.instance = PoolManager:create();
      --printInfo("PoolManager:getInstance")
      self:init()
   end
   return PoolManager.instance;
end

--对象池管理初始化 5个切换场景
function PoolManager:init()
    --printInfo("PoolManager:init")
    PoolManager.instance:poolnew("CCScene",5)
    PoolManager.instance:poolnew("CCLayer",10)
end

--[[
初始化指定类缓存个数
name:类名CCScenes         //DeprecatedClass  _G[]  获取  == functions class.__cname  加入自定义类对象缓存
size:类池大小容量
]]
function PoolManager:poolnew(cpname,size)
   size = size or 1
   --printInfo(cpname)
   --if _G[cpname] == nil then return end 
  -- printInfo(cpname.."no _G[]")
   local pool,cls = PoolManager.pmap[cpname] or {_usenum = 0},_G[cpname] or require(cpname)
   
   --dump(_G[cpname])
  -- printInfo("================================")
   --dump(cls)
   for i = 1,size do
      local obj,index = cls:create(),#pool + 1
      obj:retain()
      obj._index = index
      obj._isuse = 0
      pool[index] = obj
   end

   PoolManager.pmap[cpname] = pool
   printInfo(" PoolManager:poolnew1:"..pool[1]._index)
   printInfo(" PoolManager:poolnew2:"..pool[1]._isuse)
  -- printInfo(" PoolManager:poolnew3:"..#pool)
end

--[[
归还到池里
obj:单个实例         //DeprecatedClass  _G[]  获取  == functions class.__cname
cname:非纯lua对象时指定类名 CCScenes（一般是cocos的c++对象）
]]
function PoolManager:putInPool(obj,cname)
    if obj._isuse == 0 then return end
    local pool = PoolManager.pmap[obj.__cname]
    if(pool==nil)then
        pool = PoolManager.pmap[cname]
    end

    if(pool==nil)then return end

    local usenum = pool._usenum
    pool._usenum = usenum - 1

    local tmp,tmpindex = pool[usenum],obj._index
    pool[usenum],obj._index = obj,usenum
    pool[tmpindex],tmp._index = tmp,tmpindex
    obj._isuse = 0
    if cname ~= nil then
       -- printInfo("PoolManager:putInPool:"..cname)
        --self:getPoolNumAndSize(cname)
    end
end

--[[
是否存在该对象的池子
obj:指定对象 CCScenes         //DeprecatedClass  _G[]  获取  == functions class.__cname
]]
function PoolManager:hasObject(obj,cname)
    local pool = PoolManager.pmap[obj.__cname]
    if(pool==nil)then
        pool = PoolManager.pmap[cname]
    end

    if pool == nil then
        return false
    end
    return true
end

--[[
对象池中移除指定类所有缓存
name:类名CCScenes         //DeprecatedClass  _G[]  获取  == functions class.__cname
]]
function PoolManager:removeObject(name)
    local pool = PoolManager.pmap[name]
    if pool == nil then return end

    for _,obj in ipairs(pool) do
        obj:release()
    end
    PoolManager.pmap[name] = nil;
end

--[[
从指定类名对象池中获取一个示例对象
name:类名CCScenes         //DeprecatedClass  _G[]  获取  == functions class.__cname
]]
function PoolManager:getFromPool(name)
    local pool = PoolManager.pmap[name]
    --printInfo("PoolManager:getFromPool:"..name)
    if pool == nil then return end
    
    local usenum = pool._usenum + 1
    pool._usenum = usenum

    local  obj = pool[usenum]
    if obj == nil then
        --printInfo("PoolManager:getFromPool")
        self:poolnew(name)
        obj = pool[usenum]
    end
    obj._isuse = 1
   -- printInfo("PoolManager:getFromPoolojb:"..obj._index)
    --self:getPoolNumAndSize(name)
    return obj
end

--[[
获取对象池中指定类的使用个数和池大小
name:类名CCScenes         //DeprecatedClass  _G[]  获取  == functions class.__cname
]]
function PoolManager:getPoolNumAndSize(name)
    local pool = PoolManager.pmap[name]
   -- printInfo("getPoolNumAndSize-pool:"..name)
    if pool == nil then return 0,0 end
    printInfo("getPoolNumAndSize"..name.."//"..pool._usenum.."//"..#pool)
    return pool._usenum,#pool
end

--未来扩展
function PoolManager:drainAllPools()
    
end

--endregion
return PoolManager