local name, args = bagelBot.out()
local persist = bagelBot.getPersistence("betaBot.warps")

if persist == nil then
  bagelBot.setPersistence("betaBot.warps", {})
  persist = {}
end
if true then
  if args[1] ~= "set" and args[1] ~= "list" and args[1] ~= "remove" then
    if persist[args[1]] ~= nil then
      local location = persist[args[1]]
      commands.cofh("tpx", name, location["x"], location["y"], location["z"], location["dim"])
      bagelBot.tell(name, "Teleported to warp: &6"..args[1])
    else
      bagelBot.tell(name, "&cWarp does not exist!")
    end
  elseif args[1] == "list" then
    local str = "Warps: (&c&r) "
    local cnt = 0
    for k, _ in pairs(persist) do
      cnt = cnt+1
      str = str.."&6&h(Click to Teleport!)&g(!warp "..k..")"..k.."&r, "
    end
    str = str:sub(1, 10)..tostring(cnt)..str:sub(11)
    str = str:sub(1, -3)
    bagelBot.tell(name, str)
  elseif args[1] == "set" and betaBot.isAdmin(name) then
    if args[2] ~= nil and tonumber(args[3]) ~= nil and tonumber(args[4]) ~= nil and tonumber(args[5]) ~= nil and tonumber(args[6]) ~= nil and persist[args[2]] == nil then
      persist[args[2]] = {x = tonumber(args[3]), y = tonumber(args[4]), z = tonumber(args[5]), dim = tonumber(args[6])}
      bagelBot.setPersistence("betaBot.warps", persist)
      bagelBot.tell(name, "Warp &6&h(Click to Teleport!)&g(!warp "..args[2]..")"..args[2].."&r set!")
    else
      if persist[args[2]] ~= nil then
        bagelBot.tell(name, "&cWarp already exists!")
      else
        bagelBot.tell(name, "&cSyntax: !warp set <name> <x> <y> <z> <dimension>")
      end
    end
  elseif args[1] == "remove" and betaBot.isAdmin(name) then
    if args[2] ~= nil and persist[args[2]] ~= nil then
      table.remove(persist, args[2])
      bagelBot.setPersistence("betaBot.warps", persist)
      bagelBot.tell(name, "Removed warp: &6"..args[2].."!")
    else
      bagelBot.tell("&cWarp does not Exist!")
    end
  end
end
      
    
    
