name, args = bagelBot.out()

local admins = bagelBot.getPersistence(betaBot.admindata)
if args[1] == "set" then
	if admins then
		if betaBot.isAdmin(name) then
			admins[#admins+1] = args[2]
			bagelBot.setPersistence(betaBot.admindata, admins, false, betaBot.name)
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
			print("Added "..confirm.."to admin list.")
		end
	end
elseif args[1] == "remove" then
	if betaBot.isAdmin(name) then
		local chkadmin, loc = betaBot.isAdmin(args[2])
		if chkadmin then
			table.remove(admins, loc)
			bagelBot.tell(name, "&aAdmin "..args[2].." Demoted.", false, betaBot.name)
			bagelBot.tell(args[2], "&eYou have been Demoted.", false, betaBot.name)
		else
			bagelBot.tell(name, "&cNo such admin "..name..".", false, betaBot.name)
		end
	else
		bagelBot.tell(name, "&cYou do not have permission to use this command.", false, betaBot.name)
	end
elseif args[1] == "list" then
	bagelBot.tell(name, "Current Admins: ", false, betaBot.name)
	bagelBot.tell(name, admins, true)
end