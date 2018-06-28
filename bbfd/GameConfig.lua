--region GameConfig.lua
--Date
-- bbfriend应用内的基础配置类  // 常量配置的规范与枚举的规范
require "bbfd.init"

local UiManager = require("bbfd.managers.UiManager")
local EventManager = require("bbfd.managers.EventManager")
local NetManager = require("bbfd.managers.NetManager")
local GameManager = require("bbfd.managers.GameManager")
local PoolManager = require("bbfd.managers.PoolManager")
local DownManager = require("bbfd.managers.DownManager")
local AudioManager = require("bbfd.managers.AudioManager")
local AnimationManager = require("bbfd.managers.AnimationManager")

local bbfd = bbfd or {}
bbfd.GAME_STATES = 190
bbfd.VERSION = 1.2 --2018-5-12
--[[
1.1 基础模块mvc框架 2018-5-12
1.2 增加模块的自动销毁 2018-6-12
    增加View的自动缩放适配
    增加UIManager兼容性
    增加手机本地日志 Logger-loggerGameLog
    增加NetManager的注册回调函数处理  caoshenghui
]]
bbfd.onTV = 0 --是否安装在电视上 
bbfd.display_scalex = 1
bbfd.display_scaley = 1
bbfd.uiMgr   = UiManager:getInstance()
bbfd.evtMgr  = EventManager:getInstance()
bbfd.netMgr  = NetManager:getInstance()
bbfd.gameMgr = GameManager:getInstance()
bbfd.poolMgr = PoolManager:getInstance()
bbfd.downMgr = DownManager:getInstance()
bbfd.audioMgr  = AudioManager:getInstance()
bbfd.animMgr  = AnimationManager:getInstance()
--scenes
bbfd.baseScene = require "bbfd.scenes.BaseScene"
bbfd.baseSceneControl = require "bbfd.scenes.BaseSceneControl"
bbfd.baseComponent = require "bbfd.comps.BaseComponent"
bbfd.moduleBase = require "bbfd.core.ModuleBase"

--显示布局常量 layout
bbfd.LAYOUT_TOP_LEFT        = 1
bbfd.LAYOUT_TOP_MIDDLE      = 2
bbfd.LAYOUT_TOP_RIGHT       = 3
bbfd.LAYOUT_LEFT            = 4
bbfd.LAYOUT_RIGHT           = 5
bbfd.LAYOUT_BOTTOM_LEFT     = 6
bbfd.LAYOUT_BOTTOM_MIDDLE   = 7
bbfd.LAYOUT_BOTTOM_RIGHT    = 8

--

--endregion