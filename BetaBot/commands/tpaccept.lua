name, args = bagelBot.out()
if betaBot.tpList[name] ~= nil then
    if betaBot.tpList[name][args[1]] ~= nil then
        bagelBot.tell(name, "&eTeleport request accepted", false, betaBot.name)
        bagelBot.tell(args[1], "&eTeleport request accepted", false, betaBot.name)
        local req = betaBot.tpList[name][args[1]]
        local res
        if not req[2] then
            res = commands.tp(args[1], name)
        else
            res = commands.tp(name, args[1])
        end
        betaBot.tpList[name][args[1]] = nil
        if not res then
            bagelBot.tell(name, "&cTeleport failed, users not in same dimension", false, betaBot.name)
            bagelBot.tell(args[1], "&cTeleport failed, users not in same dimension", false, betaBot.name)
        end
        if not req[2] then
            print("&aTeleported "..args[1].." to "..name, false, betaBot.name)
        else
            print("&aTeleported "..name.." to "..args[1], false, betaBot.name)
        end
    end
else
    bagelBot.tell(name, "&cNo Teleport requests at this time", false, betaBot.name)
end
