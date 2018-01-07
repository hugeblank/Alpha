local name = bagelBot.out()
if betaBot.getLevel(name) >= betaBot.adminLevel then
  bagelBot.tell("@a", "&6Restarting... Please hold all commands until I reboot...", false, betaBot.name)
  os.reboot()
end
