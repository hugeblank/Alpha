_G.betaBot = {}
_G.betaBot.name = "</&cBeta&r>&6Bot"
_G.betaBot.tpList = {}
_G.betaBot.guess = ""
_G.betaBot.incorrect = {}
_G.betaBot.words = {}
_G.betaBot.letters = {}
_G.betaBot.game = false
_G.betaBot.admindata = "adminList" --change this if there are persistence conflicts.

_G.betaBot.isAdmin = function(name) --checks the admin list for a name
	local admins = bagelBot.getPersistence(betaBot.admindata)
	local pass = false
	for i = 1, #admins do
		if admins[i] == name then
			return true, i
		end
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