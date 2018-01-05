local name = bagelBot.out()
if betaBot.getLevel(name) >= betaBot.adminLevel then
  os.reboot
end
