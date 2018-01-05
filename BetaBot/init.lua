_G.betaBot = {}
--------Rank Levels--------
_G.betaBot.adminLevel = 2
_G.betaBot.vipLevel = 1
_G.betaBot.playerLevel = 0
---------------------------

_G.betaBot.name = "</&cBeta&r>&6Bot"
_G.betaBot.tpList = {}
_G.betaBot.guess = ""
_G.betaBot.incorrect = {}
_G.betaBot.words = {}
_G.betaBot.letters = {}
_G.betaBot.game = false
_G.betaBot.warps = "warpList"
_G.betaBot.admindata = "adminList" --change this if there are persistence conflicts.
_G.betaBot.vipdata = "vipList"
_G.betaBot.levelData = "levelList"
_G.betaBot.getLevel = function(name) --returns the level of a player
	local lList = bagelBot.getPersistence(betaBot.levelData)
	if not lList then
		bagelBot.setPersistence(bagelBot.levelData, {})
		return betaBot.playerLevel
	end
	if lList[name] then
		return tonumber(lList[name])
	end
	return betaBot.playerLevel
end
_G.betaBot.isAdmin = function(name) --checks the admin list for a name
	if betaBot.getLevel(name) == betaBot.adminLevel then
		return true
	end
	return false
end
local wordList = "https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-usa.txt"
local site = http.get(wordList)
repeat --puts the words into the thingy
    local u = site.readLine()
    if u then
        if u:len() > 5 then
           betaBot.words[#betaBot.words+1] = u
        end
    end
until u == nil
