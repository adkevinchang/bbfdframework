--region *.lua
--Date
--[[
课程框架常量与枚举管理
]]
--kevin
bbfd = bbfd or {}

--课程事件处理
bbfd.COURSE_EVENT = {
   FINISH = "course_event_finish",
   FRAGMENT_FINISH = "course_Fragment_finish",
   MULTI_FINISH = "multi_event_finish",
}

--事件类型
bbfd.COURSE_EVENT_TYPE = {
   EVENT = "event",
   INTERACT_EVENT = "interactEvent",
}

--课程多并发事件类型
bbfd.COURSE_MULTI_TYPE = {
   EVENT_DATA = "data",
   EVENT_NEXT_EVENT = "nextEvent",
}


--事件指令
bbfd.COURSE_EVENT_ORDER = {
   TITLE_EVENT = "TitleEvent",
   TIME = "Time",
   SET_SCALE = "setScale",
   SET_VISIBLE = "setVisible",
   SCALE_TO = "ScaleTo",
   MOVE_TO = "MoveTo",
   SET_FILPPED = "setFilpped",
   CLICK = "Click",
   MULTI_CLICK = "MultiClick",
   LOADING_BAR = "LoadingBar",
   SET_POSITION = "setPosition",
   SET_OPACITY = "setOpacity",
}

bbfd.COURSE_TYPE = {
  BASE = "Model",  
  OUTSIDE_GAME = "OutsideGame",  
}

bbfd.COURSE_MODEL = {
  BASE = "BaseModel",  
  EDIT_SCENE = "EditScene",  
  MUSIC_SCORE = "MusicScore", 
}

bbfd.COURSE_END_SCENE = "BackScene"

bbfd.COURSE_IDENTITY = {
    STUDENT = "student",
    TEACHER = "teacher",
}

--endregion
