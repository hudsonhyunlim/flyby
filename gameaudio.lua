local GameAudio = {}

local channelMap = {}

function GameAudio:init()
    GameAudio['descent'] = audio.loadSound("soundeffects/planesounds/descent.mp3")
    GameAudio['ascent'] = audio.loadSound("soundeffects/planesounds/ascent.mp3")
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

return GameAudio