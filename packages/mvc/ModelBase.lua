--region ModelBase.lua
--Date
--此文件由[BabeLua]插件自动生成
--处理用户本地数据与远程数据，并与逻辑类交互
--kevin

local ModelBase = class("ModelBase")
ModelBase.BbfdId = 0

function ModelBase:ctor(vo)
    --printInfo("ModelBase:ctor")
    self.vo_ = vo;
    ModelBase.BbfdId = ModelBase.BbfdId + 1
    self.bbfdId = "m"..ModelBase.BbfdId
    if self.onCreate then self:onCreate() end
end

--静态数据staticData  动态数据vo的处理使用全局cc.exports.xxx = {}
function ModelBase:onCreate()
   
end

--清除所有的内存和监听事件，置空静态数据
function ModelBase:goDispose()

end


--endregion


--region 属性管理

function ModelBase:evtMgr()
     return bbfd.evtMgr
end

function ModelBase:netMgr()
     return bbfd.netMgr
end

--当前模块功能的动态数据类
function ModelBase:getVo()
    return self.vo_
end

--endregion

return ModelBase;