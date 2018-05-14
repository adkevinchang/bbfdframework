--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
--caosh
--声音管理 胜辉

local AudioManager = class("AudioManager");
AudioManager.instance = nil;

function AudioManager:getInstance()
   if not AudioManager.instance then
      AudioManager.instance = AudioManager:create();
   end
   return AudioManager.instance;
end

function AudioManager:ctor()
    print("AudioManager:ctor")

    self.simpleAudioEngine = false
    self.isTVApp = false--GameConfig.IS_TV
end

-- 播放音乐
function AudioManager:playMusic(filePath,loop)
    loop = loop or true
    if self.isTVApp == false or self.simpleAudioEngine == false then
        return ccexp.AudioEngine:play2d(filePath,loop)
    else
        return AudioEngine.playMusic(filePath,loop)
    end
end

-- 播放背景音乐
function AudioManager:playBackgroundMusic(filePath,loop)

    print("ddddddddddd  "..filePath)
    self:stopMusic()
    self:playMusic(filePath,loop)
end

-- 停止音乐
function AudioManager:stopMusic()
    if self.isTVApp == false or self.simpleAudioEngine == false then
        ccexp.AudioEngine:stopAll()
    else
        AudioEngine.stopMusic()
    end
end

-- 暂停音乐
function AudioManager:pauseMusic(musicID)
    if self.isTVApp == false or self.simpleAudioEngine == false then
        ccexp.AudioEngine:pause(musicID)
    else
        AudioEngine.pauseMusic()
    end
end

-- 恢复音乐
function AudioManager:resumeMusic(musicID)
    if self.isTVApp == false or self.simpleAudioEngine == false then
        ccexp.AudioEngine:resume(musicID)
    else
        AudioEngine.resumeMusic()
    end
end

-- 设置音乐音量
function AudioManager:setMusicVolume(musicID,volume)
    if self.isTVApp == false or self.simpleAudioEngine == false then
        ccexp.AudioEngine:setVolume(musicID,volume)
    else
        AudioEngine.setMusicVolume(volume)
    end
end

--播放音效
function AudioManager:playEffect(filePath,loop)
    local loop = loop or false

    if self.isTVApp == false or self.simpleAudioEngine == false then
        return ccexp.AudioEngine:play2d(filePath,loop)
    else
        return AudioEngine.playEffect(filePath,loop)
    end
end

--播放音效,结束时回调
function AudioManager:playEffectCallBack(filePath,callback)
    local effectID = ccexp.AudioEngine:play2d(filePath,false)

    ccexp.AudioEngine:setFinishCallback(effectID,callback)

    return effectID
end

-- 停止音效
function AudioManager:stopEffect(effectID)
    if self.isTVApp == false or self.simpleAudioEngine == false then
        ccexp.AudioEngine:stop(effectID)
    else
        AudioEngine.stopEffect(effectID)
    end
end

-- 停止所有音效
function AudioManager:stopAllEffect()
    if self.isTVApp == false or self.simpleAudioEngine == false then
        ccexp.AudioEngine:stopAll()
    else
        AudioEngine.stopAllEffects()
    end
end

-- 暂停音效
function AudioManager:pauseEffect(effectID)
    if self.isTVApp == false or self.simpleAudioEngine == false then
        ccexp.AudioEngine:pause(effectID)
    else
        AudioEngine.pauseEffect(effectID)
    end
end

-- 恢复音效
function AudioManager:resumeEffect(effectID)
    if self.isTVApp == false or self.simpleAudioEngine == false then
        ccexp.AudioEngine:resume(effectID)
    else
        AudioEngine.resumeEffect(effectID)
    end
end

--清理缓存
function AudioManager:uncacheSoundFile(filePath)
    ccexp.AudioEngine:uncache(filePath)
end

return AudioManager
--endregion
