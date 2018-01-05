local name = bagelBot.out()
local x, y, z = betaBot.getPos(name)
commands.summon("FireworksRocketEntity", x, y, z, "{LifeTime:20,FireworksItem:{id:fireworks,Count:1,tag:{Fireworks:{Explosions:[{Type:1,Flicker:1,Trail:1,Colors:[1182463],FadeColors:[16711680]}]}}}}")
