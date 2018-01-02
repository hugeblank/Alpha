name, args = bagelBot.out()
if betaBot.tpList[name] ~= nil then
    if betaBot.tpList[name][args[1]] ~= nil then
        bagelBot.tell(name, "&eTeleport request accepted")
        bagelBot.tell(args[1], "&eTeleport request accepted")
        local req = betaBot.tpList[name][args[1]]
        if not req[2] then --commands.tpl is from FTBUtilities.
            commands.tpl(args[1], name)
        else
            commands.tpl(name, args[1])
        end
        betaBot.tpList[args[1]] = nil
        if not req[2] then
            print("&aTeleported "..args[1].." to "..name)
        else
            print("&aTeleported "..name.." to "..args[1])
        end
    end
else
    bagelBot.tell(name, "&cNo Teleport requests at this time")
end
