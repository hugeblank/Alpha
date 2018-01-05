name, args = bagelBot.out()

local levels = bagelBot.getPersistence(betaBot.levelData)
if args[1] == "set" then
	if levels then
		if betaBot.isAdmin(name) then
			levels[args[2]] = tonumber(args[3])
			bagelBot.setPersistence(betaBot.levelData, levels)
			bagelBot.tell(name, "&a"..args[2].." is now an admin.", false, betaBot.name)
			bagelBot.tell(args[2], "&eYou have been Promoted.", false, betaBot.name)
		else
			bagelBot.tell(name, "&cYou do not have permission to use this command.", false, betaBot.name)
		end
	else
		bagelBot.tell(name, "No admins exist. Please confirm you are opped by going into the bot command computer and typing in your minecraft username.", false, betaBot.name)
		local confirm = read()
		if confirm == name then
			print(betaBot.admindata)
			bagelBot.setPersistence(betaBot.admindata, {name})
			print("Added "..name.."to admin list.")
		end
	end
elseif args[1] == "list" then
	bagelBot.tell(name, "Current Admins: ", false, betaBot.name)
	for k, v in pairs(levels) do
		if tonumber(v) and tonumber(v) >= tonumber(betaBot.adminLevel) then
			bagelBot.tell(name, k, true)
		end
	end
end
