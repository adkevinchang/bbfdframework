--region *.lua
--Date
--网络通讯的常量配置
bbfd = bbfd or {}

--远程地址

bbfd.NET_GET_ADDRESS = "http://sub.bbfriend.com/"
bbfd.NET_SOCKET_ADDRESS = "http://main.bbfriend.com/"
bbfd.NET_SUB_ADDRESS = "http://sub.bbfriend.com/"--主线任务
bbfd.NET_RES_SOCKET_ADDRESS = "http://game.bbfriend.com/"
bbfd.NET_PAY_ADDRESS = "http://paygame.bbfriend.com/"  --支付相关的接口地址, 测试http://paytest.bbfriend.com/  paygame
-- bbfd.payAddress = "http://192.168.1.151:82/"  --支付相关的接口地址, 测试http://paytest.bbfriend.com/  paygame

bbfd.NET_HOT_ADDRESS = "http://game.bbfriend.com/"
bbfd.NET_UPLOAD_ADDRESS = "http://upload.bbfriend.com/"
bbfd.NET_DOWNLOAD_ADDRESS = "http://image.bbfriend.com/"

bbfd.NET_MODEL = "youjiao"

--本地地址
--热更本地配置文件地址
bbfd.LOCAL_MANIFESTS = "project.manifest"

--客户端缓存地址
bbfd.STORAGE_PATHS = "bbfd/ddyj"

--本地测试 http://192.168.1.170/weixin/remote-assets
--endregion
