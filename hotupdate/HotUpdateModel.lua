--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
--kevin
require("app.views.hotupdate.HotEventConstants")

local HotUpdateModel = class("HotUpdateModel",cc.load("mvc").ModelBase);

--CreateHandler
function HotUpdateModel:onCreate()
    self.evtMgr():AddListener(bbfd.HOT_EVENT_JUMP,handler(self, self.goDispose))

    --读取本地json文件
    self.am = cc.AssetsManagerEx:create(bbfd.LOCAL_MANIFESTS,cc.FileUtils:getInstance():getWritablePath() .. bbfd.STORAGE_PATHS)
    self.am:retain()

    if not self.am:getLocalManifest():isLoaded() then
        print("Fail to update assets, step skipped.")
        self.evtMgr():Brocast(bbfd.HOT_EVENT_FINISH)  --纷发“完成”的事件 
    else
        local function onUpdateEvent(event)
            local eventCode = event:getEventCode()
            if eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_NO_LOCAL_MANIFEST then
                print("热更失败，本地没有manifest文件，跳过更新")

                self.evtMgr():Brocast(bbfd.HOT_EVENT_FINISH)  --纷发“完成”的事件 
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

                self.evtMgr():Brocast(bbfd.HOT_EVENT_PROGRESS, percent)
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_DOWNLOAD_MANIFEST or 
                eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_PARSE_MANIFEST then
                print("热更失败，下载远程的manifest文件失败，跳过更新")

                self.evtMgr():Brocast(bbfd.HOT_EVENT_FINISH)  --纷发“完成”的事件   
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ALREADY_UP_TO_DATE or 
                eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_FINISHED then
                print("热更完成！")
                
                self.evtMgr():Brocast(bbfd.HOT_EVENT_FINISH)
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_UPDATING then
                printInfo("Asset ", event:getAssetId(), ", ", event:getMessage())
                
                self.evtMgr():Brocast(bbfd.HOT_EVENT_FINISH)  --纷发“完成”的事件 

                print("某个资源热更失败:资源id="..event:getAssetId(), ">>", event:getMessage())
            end
        end
        self.listener = cc.EventListenerAssetsManagerEx:create(self.am,onUpdateEvent)
        cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(self.listener, 1)
        
        self.am:update()
    end

    self:getRemoteVertion()
end

function HotUpdateModel:getRemoteVertion()
   
end

--释放
function HotUpdateModel:goDispose()
    if self.listener ~= nil then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.listener)
        self.listener = nil
    end
    self.am:release()
end

--endregion
return HotUpdateModel