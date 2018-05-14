--region ModuleBase.lua
--Date
--此文件由[BabeLua]插件自动生成
--caosh
--模块基类，管理mvc模块 胜辉

local ModuleBase = class("ModuleBase")

function ModuleBase:ctor()
    self.packages = {}
    self.mvc = {}
    self.viewIsShow = false
    self:importPackages()
    self:onCreate()
end

function ModuleBase:onCreate()
    --重写  在此初始化模块自身数据 传递给mvc的数据也在此初始化 不写也行~~~~
end

function ModuleBase:importPackages()
    --重写 导入模块mvc包
    -- self.packages.m = rqueire "ModController path"
    -- self.packages.v = rqueire "ModView path"
    -- self.packages.c = rqueire "ModController path"
    --
end

function ModuleBase:createMVC(...)
    if self.mvc.m == nil then self.mvc.m = self.packages.m and self.packages.m:create(...) or nil end
    if self.mvc.v == nil then self.mvc.v = self.packages.v and self.packages.v:create(nil, nil, ...) or nil end
    if self.mvc.c == nil then self.mvc.c = self.packages.c and self.packages.c:create(self.mvc.v, self.mvc.m, ...) or nil end
    if self.mvc.v then
		self.mvc.v:setDestroy(handler(self,ModuleBase.destroy))
    end
end

--必须在实现自身view层后调用
function ModuleBase:showModuleToView(view,...)
    self:createMVC(...)
    self.mvc.v:addTo(view,self._ZORDER)
    self.viewIsShow = true
end

--移除view
function ModuleBase:hideView()
    if self.mvc and self.mvc.v and self.viewIsShow then
        self.mvc.v:playCloseAction()
--        self.mvc.v:removeSelf()
        self.viewIsShow = false
    end
end

--销毁 有View则在View释放时自动调用 没有则需手动确定调用位置
function ModuleBase:destroy()
    print("ModuleBase:destroy()")
    if self.mvc then
        self.mvc.v = nil
        if self.mvc.c then
            self.mvc.c:destroy()
        end
        if self.mvc.m then
            self.mvc.m:destroy()
        end
    end
    self.viewIsShow = nil
    self.packages = nil
    self.mvc = nil
end

return ModuleBase
--endregion