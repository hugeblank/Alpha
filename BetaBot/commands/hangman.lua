name, args = bagelBot.out()
local word = function()
    local w = ""
    for k, v in pairs(betaBot.letters) do w = w..v[1] end
    return w
end
if betaBot.game ~= true then
    if args[1] == "start" then
        betaBot.game = true
        betaBot.letters = {}
        for k in string.gmatch(betaBot.words[math.random(1, #betaBot.words)] , ".") do
            betaBot.letters[#betaBot.letters+1] = {k, false}
        end
        betaBot.guess = ""
        for k, v in pairs(betaBot.letters) do
            betaBot.guess = betaBot.guess.."_ "
        end
        bagelBot.tell("@a", "&6Game of hangman started! type !hangman and your single letter guess or the whole word.\\nHint: &1"..betaBot.guess, false, betaBot.name)
    else
        bagelBot.tell(name, "&6Classic hangman! to start a game type or click: &c&g(!hangman start)!hangman start&6 to start a game!", false, betaBot.name)
    end
else
    if args[1] == nil then
        bagelBot.tell(name, "&cPlease provide a letter to guess!", false, betaBot.name)
        betaBot.guess = ""
        for k, v in pairs(betaBot.letters) do
            if v[2] == false then
                betaBot.guess = betaBot.guess.."_ "
            else
                betaBot.guess = betaBot.guess..v[1].." "
            end
        end
        bagelBot.tell("@a", "&1"..betaBot.guess, false, betaBot.name)
        bagelBot.tell("@a", "&6"..tostring(#betaBot.incorrect).." incorrect guesses!", false, betaBot.name)
    else
        local test = false
        if string.len(args[1]) == 1 then
            for k, v in pairs(betaBot.letters) do
                if v[1] == string.lower(args[1]:sub(1, 1)) then
                    betaBot.letters[k][2] = true
                    test = true
                end
            end
        else
            if args[1] == string.lower(word()) then
                test = true
                for k, v in pairs(betaBot.letters) do
                    v[2] = true
                end
            end
        end
        if test == true then
            bagelBot.tell("@a", name.." &2guessed correctly!", false, betaBot.name)
            local cnt = 0
            local cntMx = 0
            for _, v in pairs(betaBot.letters) do
                cntMx = cntMx+1
                if v[2] == true then
                    cnt = cnt+1
                end
            end
            if cnt == cntMx then
                bagelBot.tell("@a", "&2You Won! The word was: &6"..word(), false, betaBot.name)
                betaBot.game = false
            end
        else
            betaBot.incorrect[#betaBot.incorrect+1] = args[1]
            bagelBot.tell("@a", name.." &cguessed incorrectly!", false, betaBot.name)
            if #betaBot.incorrect >= 10 then
                bagelBot.tell("@a", "&cRan out of guesses! game over! The word was: &6"..word(), false, betaBot.name)
                betaBot.game = false
            else
                bagelBot.tell("@a", "&6"..tostring(10-#betaBot.incorrect).." guesses left", false, betaBot.name)
            end
        end
        if betaBot.game then
            betaBot.guess = ""
            for k, v in pairs(betaBot.letters) do
                if v[2] == true then
                    betaBot.guess = betaBot.guess..v[1].." "
                else
                    betaBot.guess = betaBot.guess.."_ "
                end
            end
            bagelBot.tell("@a", "&1"..betaBot.guess, false, betaBot.name)
        else 
            betaBot.incorrect = {}
            betaBot.guess = ""
            betaBot.letters = {}
        end
    end
end
