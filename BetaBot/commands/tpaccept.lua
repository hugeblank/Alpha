name, args = bagelBot.out()
if betaBot.tpList[name] ~= nil then
    if betaBot.tpList[name][args[1]] ~= nil then
        bagelBot.tell(name, "&eTeleport request accepted", false, betaBot.name)
        bagelBot.tell(args[1], "&eTeleport request accepted", false, betaBot.name)
        local req = betaBot.tpList[name][args[1]]
        if not req[2] then --commands.tpl is from FTBUtilities.
            commands.exec("cofh tpx ", args[1], name)
        else
            commands.exec("cofh tpx ", name, args[1])
        end
        betaBot.tpList[args[1]] = nil
        if not req[2] then
            print("&aTeleported "..args[1].." to "..name, false, betaBot.name)
        else
            print("&aTeleported "..name.." to "..args[1], false, betaBot.name)
        end
    end
else
    bagelBot.tell(name, "&cNo Teleport requests at this time", false, betaBot.name)
end
