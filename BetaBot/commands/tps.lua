name = bagelBot.out()
local _, tps = commands.forge("tps")
bagelBot.tell(name, tps[#tps], false, betaBot.name)