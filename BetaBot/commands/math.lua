local name, args = bagelBot.out()
local eqn = ""
local hf = true
for i = 1, #args do
    eqn = eqn..args[i]
end
if eqn:find("function") then hf = false end
if hf then
    local ver
    local func = loadstring("return "..eqn)
    if func then
        setfenv(func, {math = math})
        ver, ans = pcall(func)
    else
        ver = false
    end
    if ver then
        bagelBot.tell(name, "&2Answer: &6"..tostring(ans), false, betaBot.name)
    else
        bagelBot.tell(name, "&cNot a valid equation!", false, betaBot.name)
    end
else
    bagelBot.tell(name, "&cOkay you can stop trying to test the bounds now.", false, betaBot.name)
end
