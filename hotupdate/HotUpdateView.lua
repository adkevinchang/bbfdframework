--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local HotUpdateView = class("HotUpdateView",cc.load("mvc").ViewBase);
HotUpdateView.RESOURCE_FILENAME = "Login/HotUpdateView.csb"
HotUpdateView.RESOURCE_BINDING ={
   panel = {varname = "panel"}
}

--CreateHandler
function HotUpdateView:onCreate()
	self.Panel_Progress:setVisible(false)
    self.Button_Jump:setVisible(false)
    self["progressBar"]:setPercent(0)
end

--显示
function HotUpdateView:showWithScene(transition, time, more)
    self:setVisible(true)
    local scene = self:poolMgr():getFromPool("CCScene")
    scene.name_ = "HotUpdateScene"
    self:uiMgr():initScene(scene)
    self:uiMgr():getGameLayer():addChild(self)
    display.runScene(scene, transition, time, more)
    return self
end

--EnterTransitionFinishHandler
function HotUpdateView:onEnterTransitionFinish()
    if utils.socketAddress == "http://maintest.bbfriend.com/" then
        utils.commonMsg(self,utils.MsgType.TopSingle,"当前是在测试服务器!")
    end
end

--释放
function HotUpdateView:goDispose()
  HotUpdateView.super.goDispose(self)
    -- self:removeFromParent()  

end

return HotUpdateView
--endregion
