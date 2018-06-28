--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
require("app.views.hotupdate.HotEventConstants")

local HotUpdateControl = class("HotUpdateControl",cc.load("mvc").ControlBase)
HotUpdateControl.RESOURCE_FILENAME = "Login/HotUpdateView.csb"
HotUpdateControl.RESOURCE_BINDING ={
   panel = {varname = "panel"}
}

--CreateHandler
function HotUpdateControl:onCreate()
    self.Panel_Progress:setVisible(false)
    self.Button_Jump:setVisible(false)
    
    self.Button_Jump:addClickEventListener(handler(self, self.onClikJumpBtn))
    
    -- self.updateFinishHandler = handler(self, self.onUpdateFinish)
    -- self.evtMgr():AddListener(bbfd.HOT_EVENT_FINISH,self.updateFinishHandler)

    -- self.progressHanlder = handler(self, self.onProgress)
    -- self.evtMgr():AddListener(bbfd.HOT_EVENT_PROGRESS, self.progressHanlder)
    
    -- local netState = checkNetworkState()
    -- if netState == 0 then
    --   print("当前没有网络,走无网逻辑！")
    --   self:onUpdateFinish()
    -- else
    --   print("当前有网络,首先获取网关配置")
      local params = {channel=GAME_SETTING.channle, version=GAME_SETTING.version, key=getDeviceID(), appSign="DDYJ_Teacher"}
      print("获取网关配置:params="..json.encode(params))
      utils.sendHttp("api/gateway", params, handler(self, self.onGotGateway), "sub")
    -- end
end

--获取到网关配置
function HotUpdateControl:onGotGateway(param)
    print("获取到的网关配置:", json.encode(param))
    if param and param.code == 200 then
      PlayerData.mainURL, utils.socketAddress = param.data.mainURL, param.data.mainURL
      PlayerData.subURL, utils.subAddRess = param.data.subURL, param.data.subURL 
      PlayerData.resourceURL, utils.resSocketAddress = param.data.resourceURL, param.data.resourceURL
      PlayerData.shopURL, utils.payAddress = param.data.shopURL, param.data.shopURL
      PlayerData.hotURL, utils.hotAddress = param.data.hotURL, param.data.hotURL
      PlayerData.uploadURL, utils.uploadAddress = param.data.uploadURL, param.data.uploadURL
      PlayerData.downloadURL, utils.downLoadAddRess = param.data.downloadURL, param.data.downloadURL
      PlayerData.brainsGameURL, utils.brainsGameAddRess = param.data.brainsGameURL, param.data.brainsGameURL
      
      if param.data.iconRootURL then 
          PlayerData.iconRootURL, utils.headAddress = param.data.iconRootURL, param.data.iconRootURL
      end
      if param.data.paintRootURL then 
          PlayerData.paintRootURL, utils.paintDownLoadAddRess = param.data.paintRootURL, param.data.paintRootURL
      end

      utils.brainsGameAddRess = "http://oss.bbfriend.com/cocos/ddtcyj/brainsGame/"
      PlayerData.brainsGameURL = "http://oss.bbfriend.com/cocos/ddtcyj/brainsGame/"

      PlayerData.savePlayerData()

      self:startHotUpdate()
    else
      self:onUpdateFinish()      
    end
end

--开启热更
function HotUpdateControl:startHotUpdate()
    --读取本地json文件
    self.am = cc.AssetsManagerEx:create(bbfd.LOCAL_MANIFESTS,cc.FileUtils:getInstance():getWritablePath() .. bbfd.STORAGE_PATHS)
    self.am:retain()

    if not self.am:getLocalManifest():isLoaded() then
        print("Fail to update assets, step skipped. 找不到本地的manifest文件")
        self:onUpdateFinish()
    else
        local function onUpdateEvent(event)
            local eventCode = event:getEventCode()
            if eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_NO_LOCAL_MANIFEST then
                print("热更失败，本地没有manifest文件，跳过更新")
                self:onUpdateFinish() 
            elseif  eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_PROGRESSION then
                local assetId = event:getAssetId()
                local percent = event:getPercent()
                local strInfo = ""
                if assetId == cc.AssetsManagerExStatic.VERSION_ID then
                    strInfo = string.format("Version file: %d%%", percent)
                elseif assetId == cc.AssetsManagerExStatic.MANIFEST_ID then
                    strInfo = string.format("Manifest file: %d%%", percent)
                else
                    strInfo = string.format("%d%%", percent)
                end
                print("正在热更新:strInfo="..strInfo)
                self:onProgress(percent)
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_DOWNLOAD_MANIFEST or 
                eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_PARSE_MANIFEST then
                print("热更失败，下载远程的manifest文件失败，跳过更新")
                self:onUpdateFinish()   
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ALREADY_UP_TO_DATE or 
                eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_FINISHED then
                print("热更完成！")
                self:onUpdateFinish()
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_UPDATING then
                printInfo("Asset ", event:getAssetId(), ", ", event:getMessage())
                self:onUpdateFinish() 
                print("某个资源热更失败:资源id="..event:getAssetId(), ">>", event:getMessage())
            end
        end
        self.listener = cc.EventListenerAssetsManagerEx:create(self.am,onUpdateEvent)
        cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(self.listener, 1)
        
        self.am:update()
    end
end

--创建模块 初始化
function HotUpdateControl:initFunMod()
   local mod = nil--require("app.views.hotupdate.HotUpdateModel"):create()
   local view = require("app.views.hotupdate.HotUpdateView"):create()
   self:initCtor(view,mod)
   view:showWithScene()
end

--点击跳过按钮
function HotUpdateControl:onClikJumpBtn()
  self:onUpdateFinish()
end

--更新进度显示
function HotUpdateControl:onProgress(progress)
  if progress ~= nil then
    if tonumber(progress) > 0 then 
        self.Panel_Progress:setVisible(true)
        self.Button_Jump:setVisible(true)
    end
    self.Panel_Progress:getChildByName("progressBar"):setPercent(progress)
  end
end

--更新完毕
function HotUpdateControl:onUpdateFinish()
  self.Panel_Progress:getChildByName("progressBar"):setPercent(100)
  self.Button_Jump:setVisible(true)

  self:getView():removeFromParent()
  self:goDispose()

  createGameControl("app.views.login.LoginControl")
  print("热更新\"完毕\",创建登录模块")
end

--释放
function HotUpdateControl:goDispose()
  if self.updateFinishHandler ~= nil then
    self.evtMgr():removeListener(bbfd.HOT_EVENT_FINISH, self.updateFinishHandler)
    self.updateFinishHandler = nil
  end

  if self.progressHanlder ~= nil then
    self.evtMgr():removeListener(bbfd.HOT_EVENT_PROGRESS, self.progressHanlder)
    self.progressHanlder = nil
  end

  if self.listener ~= nil then
      cc.Director:getInstance():getEventDispatcher():removeEventListener(self.listener)
      self.listener = nil
  end

  if self.am ~= nil then
    self.am:release()
    self.am = nil
  end

  HotUpdateControl.super.goDispose(self)
end

--endregion
return HotUpdateControl