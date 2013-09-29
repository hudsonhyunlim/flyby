local GameAudio = {}

local channelMap = {}

function GameAudio:init()
    GameAudio['descent'] = audio.loadSound("soundeffects/planesounds/descent.mp3")
    GameAudio['ascent'] = audio.loadSound("soundeffects/planesounds/ascent.mp3")
    GameAudio['crash'] = audio.loadSound("soundeffects/planesounds/crash.mp3")
    GameAudio['opening'] = audio.loadSound("soundeffects/background/opening.mp3")
    GameAudio['gameplay'] = audio.loadSound("soundeffects/background/gameplay.mp3")
    GameAudio['fuel'] = audio.loadSound("soundeffects/planesounds/refuel_whenugetacrate.mp3")
end

function GameAudio:playLoop(file, options)
    if(not channelMap[file]) then
        channelMap[file] = audio.play(GameAudio[file], options)
    end
end

function GameAudio:stopLoop(file)
    if(GameAudio[file] and channelMap[file]) then
        audio.stop(channelMap[file])
        channelMap[file] = nil
    end
end

function GameAudio:setVolume(file, volume)
    audio.setVolume(volume, {channel=channelMap[file]})
end

function GameAudio:playOnce(file, options)
    audio.play(GameAudio[file], options)
end

return GameAudio