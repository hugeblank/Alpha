local name, args = bagelBot.out()
local isAFK = bagelBot.getPersistence("isAFK")
if isAFK == nil then isAFK = {} end
local afk = false
for i = 1, #isAFK do
    if isAFK[i][1] == name then
        afk = true
    end
end
if afk == false then
    local amod = {}
    local _, res = commands.tp(name, "~ ~ ~")
    for i in res[1]:gmatch("%S+") do
        amod[#amod+1] = i:gsub("[,]", "")
    end
    bagelBot.tell("@a", "&6*"..name.." is AFK.")
    print(name.." is AFK.")
    isAFK[#isAFK+1] = {name, amod[4], amod[5], amod[6]}
    commands.setblock(amod[4], "253", amod[6], "barrier 0")
    commands.tp(name, amod[4], "254", amod[6])
    bagelBot.setPersistence("isAFK", isAFK)
else
    for i = 1, #isAFK do
        if isAFK[i][1] == name then
            local temppos = isAFK[i]
            table.remove(isAFK, i)
            bagelBot.setPersistence("isAFK", isAFK)
            commands.setblock(temppos[2], "253", temppos[4], "air 0")
            commands.tp(table.concat(temppos, " "))
            bagelBot.tell("@a", "&6*"..name.." is no longer AFK.")
            print(name.." is no longer AFK.")
        end
    end
end