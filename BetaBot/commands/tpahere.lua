name, args = bagelBot.out()
if type(betaBot.players[args[1]]) == "nil" then
    args[1] = nil
    bagelBot.tell(name, "&cPlayer does not exist or is not online.")
end
if not args[1] == nil then
    print(bagelBot.tell(args[1], name.." would like you to teleport to them, type or click: &6&g(!tpaccept)!tpaccept "..name.."&r to accept"))
    bagelBot.tell(name, "&eSent Teleport Request To: &6"..args[1])
    if betaBot.tpList[args[1]] == nil then
        betaBot.tpList[args[1]] = {}
    end
    betaBot.tpList[args[1]][name] = {name, true}
end
