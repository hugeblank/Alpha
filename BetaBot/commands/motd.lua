name, args = bagelBot.out()
local admins = bagelBot.getPersistence(betaBot.admindata)
if args[1] == nil then
	if fs.exists("/motd.txt") then
		motd = fs.open("/motd.txt", "r")
		bagelBot.tell(name, motd.readAll())
		motd.close()
	else
		bagelBot.tell(name, "&a Welcome to the server!")
	end
elseif args[1] == "set" then
	if betaBot.isAdmin(name) then
		motd = fs.open("../motd.txt", "w")
		for i = 2, #args do
			motd.write(args[i])
		end
		motd.close()
		bagelBot.tell(name, "&aMoTD set!")
	else
		bagelBot.tell(name, "&cYou do not have permission to use this command.")
	end
end
