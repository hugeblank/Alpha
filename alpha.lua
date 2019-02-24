if not allium then
    printError("This plugin needs to be executed by Allium in order to function.")
end
local this = allium.register("Alpha")

local alpha = {
    hangman = {guess = "", incorrect = {}, words = {}, letters = {}, game = false},
    tp_list = {},
    warps = "warps",
    admins = "admins",
    afk = "afk"
}

local function warps()
    local list = this.getPersistence(alpha.warps)
    if list then
        local out = {}
        for warp in pairs(list) do
            print(warp)
            out[#out+1] = warp
        end
        return out
    end
    return {}
end

local info = {
    admin = {
        "Perform operations on people that can manipulate vital information in Alpha.",
        promote = {
            "Promote someone to admin",
            name = {
                "Username of the player to promote",
                infill = "username"
            }
        },
        demote = {
            "Demote someone from admin",
            name = {
                "Username of the player to demote",
                infill = "username"
            }
        },
        list = {
            "List all admins"
        }
    },
    afk = {
        "Toggles players AFK state"
    },
    colors = {
        "Displays a formatting demonstration"
    },
    credits = {
        "See who made Alpha"
    },
    firework = {
        "Creates a firework at your location"
    },
    hangman = {
        "Play a game of hangman!",
        start = {
            "Start the game"
        },
        ["guess a-z"] = {
            clickable = false,
            optional = true,
            "While a game is being played, guess a letter"
        }
    },
    math = {
        "Performs any math equation you throw at it!",
        equation = {
            clickable = false,
            "Any mathematical equation [ex: &e&g[[!alpha:math ((2*1)+7*5)%12]]&h[[Click for answer!]]((2*1)+7*5)%10&r]"
        }
    },
    motd = {
        "Provides the Message Of The Day",
        set = {
            "set the MOTD (must be admin)",
            message = {
                clickable = false,
                "Formatted text"
            }
        }
    },
    ping = {
        "Returns a pong to the user."
    },
    reboot = {
        "Reboots the computer executing allium"
    },
    rtp = {
        "Teleport to a random location"
    },
    rules = {
        "View the laws of the land"
    },
    sudo = {
        "Executes a command as a targeted user",
        name = {
            infill = "username",
            "Name of user to target",
            chat = {
                "Chat as the targeted user",
                text = {
                    default = "The admins on this server are the best!",
                    "Message to submit to chat with"
                }
            },
            command = {
                infill = "command",
                "Command to execute as the targeted user"
            }
        }
    },
    tpa = {
        "Request to teleport to another player",
        name = {
            infill = "username",
            "Username of the player to teleport to"
        }
    },
    tpaccept = {
        "Accept a teleport request",
        name = {
            infill = "username",
            "Username of the requesting player"
        }
    },
    tpahere = {
        "Request a player to teleport to you",
        name = {
            infill = "username",
            "Username of the player to request"
        }
    },
    tps = {
        "Get the Ticks Per Second of the server"
    },
    warp = {
        "Teleports you to a pre-defined warp area",
        name = {
            infill = warps,
            "Name of the warp you want to travel to"
        },
        list = {
            "List all warp options"
        },
        set = {
            "Create a warp at your current position (must be admin)",
            name = {
                infill = warps,
                "Name of the warp you want to create"
            }
        },
        remove = {
            "Remove a warp option",
            name = {
                infill = warps,
                "Name of warp to remove"
            }
        }
    }
}

local orig_print = print
local function print(...) -- Print function specially made for alpha
    local args, argstr = {...}, ""
    if #args > 1 then
        for i = 1, #args do
            argstr = argstr.." "..tostring(args[i])
        end
    else
        argstr = tostring(args[1])
    end
    return orig_print("Alpha: "..argstr)
end

alpha.isAdmin = function(name) -- Check if player is an admin
    local data = this.getPersistence(alpha.admins)
    if data then
        for i = 1, #data do
            if name == data[i] then
                return true
            end
        end
    end
    return false
end

do -- Get words for hangman
    local site = http.get("https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-usa.txt")
    if site then
        repeat --puts the words into table
            local u = site.readLine()
            if u and u:len() > 5 then
                alpha.hangman.words[#alpha.hangman.words+1] = u
            end
        until u == nil
        site.close()
    end
end

local function admin(name, args, data)
    do -- Arguments check
        if not (args[1] == "list" or args[1] == "promote" or args[1] == "demote") then
            data.error()
            return
        end
        if args[1] ~= "list" then
            local players = allium.getPlayers()
            local found = false
            for i = 1, #players do 
                if players[i] == args[2] then
                    found = true
                    break
                end
            end
            if not found then
                data.error("Could not find player "..("" or args[2]))
                return
            end
        end
    end

    local admin_list = this.getPersistence(alpha.admins) 
    if not admin_list then admin_list = {} end

    if args[1] == "promote" then
        if #admin_list > 0 then
            if alpha.isAdmin(name) and not alpha.isAdmin(args[2]) then
                admin_list[#admin_list+1] = name
                this.setPersistence(alpha.admins, admin_list)
                print(args[2].." has been promoted to admin")
                allium.tell(name, "&a"..args[2].." has been promoted to admin")
                allium.tell(args[2], "&aYou have been Promoted")
            elseif alpha.isAdmin(args[2]) then
                data.error(args[2].." is already an admin")
            else
                data.error("You do not have permission to use this command")
            end
        else
            allium.tell(name, "No admins exist. Please confirm you are opped by going into the command computer Allium is on and typing in your minecraft username")
            local confirm = read()
            if confirm == name then
                admin_list[#admin_list+1] = name
                this.setPersistence(alpha.admins, admin_list)
                print(name.." has been promoted to admin")
                allium.tell(name, "&aYou have been promoted")
            else
                print(confirm.." is not "..name..", not promoting "..name)
                data.error("&h[[Incorrect name was given to the computer.]]You have not been promoted")
            end
        end
    elseif args[1] == "demote" then
        if #admin_list > 0 then
            if alpha.isAdmin(name) then
                for i = 1, #admin_list do
                    if name == admin_list[i] then
                        table.remove(admin_list, i)
                        print(args[2].." has been demoted from admin")
                        allium.tell(name, "&a"..args[2].." has been demoted from admin")
                        allium.tell(args[2], "&cYou have been demoted")
                        break
                    end
                end
                this.setPersistence(alpha.admins, admin_list)
            else
                data.error("You do not have permission to use this command")
            end
        else
            data.error("No admins to demote")
        end
    elseif args[1] == "list" then
        if #admin_list > 0 then
            local str = ""
            for i = 1, #admin_list do
                str = str.."\n&6-&r "..admin_list[i]
            end
            allium.tell(name, "&aAdmins:&r"..str)
        else
            data.error("No admins exist")
        end
    end
end

-- alpha:admin
this.command("admin", admin, info.admin, "<promote | demote | list> <username>")

local function afk(name, _, data)
    local afk = this.getPersistence(alpha.afk)
    if not afk then afk = {} end
    local is_afk = false
    for i = 1, #afk do
        if afk[i][1] == name then
            is_afk = true
        end
    end
    if not is_afk then
        local x, y, z = allium.getPosition(name)
        if x then
            allium.tell("@a", "&7*"..name.." is AFK.")
            print(name.." is AFK.")
            afk[#afk+1] = {name, x, y, z}
            commands.setblock(x, "253", z, "barrier 0")
            this.setPersistence(alpha.afk, afk)
        else
            data.error("Could not set you AFK.")
        end
    else
        for i = 1, #afk do
            if afk[i][1] == name then
                local temppos = afk[i]
                table.remove(afk, i)
                this.setPersistence(alpha.afk, afk)
                commands.setblock(temppos[2], "253", temppos[4], "air 0")
                commands.tp(table.concat(temppos, " "))
                allium.tell("@a", "&7*"..name.." is no longer AFK.")
                print(name.." is no longer AFK.")
            end
        end
    end
end

-- alpha:afk
-- this.command("afk", afk, info.afk) Deprecated due to removal of getPosition for 1.11 and 1.12

local function colors(name)
    allium.tell(name, "&11&22&33&44&55&66&77&88&99&00&aa&bb&cc&dd&ee&ff\\n &r&h[[With hovering text]]newline!&r&i[[https://github.com/hugeblank/alpha]]&b[Link]&r&lBold!&r&nUnderLined!&r&oItallic&r&kMagic!&r&mstrikethrough")
end

-- alpha:colors
this.command("colors", colors, info.colors)

local function credits(name)
    allium.tell(name, "Inspired by &1&i[[https://github.com/roger109z]]roger109z&r and adapted to &dAll&5i&r&dum&r by &a&i[[https://github.com/hugeblank]]hugeblank&r. View &b&lA&r&9lpha&r at &9&n&ihttps://github.com/hugeblank/alpha/&r")
end

-- alpha:credits
this.command("credits", credits, info.credits)


local function firework(name)
    local x, y, z = allium.getPosition(name)
    local suc, err = commands.summon("minecraft:fireworks_rocket "..x.." "..y.." "..z.." ".."{LifeTime:20,FireworksItem:{id:fireworks,Count:1,tag:{Fireworks:{Explosions:[{Type:1,Flicker:1,Trail:1,Colors:[1182463],FadeColors:[16711680]}]}}}}")
    if not suc then printError(textutils.serialize(err)) end
end

-- alpha:firework
-- this.command("firework", firework, info.firework) Deprecated due to removal of getPosition for 1.11 and 1.12

local function hangmanGame(name, args)
    local hangman = alpha.hangman
    if hangman.game ~= true then
        if args[1] == "start" then
            hangman.game = true
            hangman.letters = {}
            hangman.word = hangman.words[math.random(1, #hangman.words)]:lower()
            for k in hangman.word:gmatch(".") do
                hangman.letters[#hangman.letters+1] = {letter = k, guessed = false}
            end
            hangman.guess = string.rep("_ ", #hangman.letters):sub(1, -2)
            allium.tell("@a", "&6Game of hangman started! type !hangman and your single letter guess or the whole word.\\nHint: &1"..hangman.guess)
        else
            allium.tell(name, "&6Classic hangman! to start a game type or click: &c&g[[!hangman start]]!hangman start&6 to start a game!")
        end
    else
        if args[1] == nil then
            allium.tell(name, "&cPlease provide a letter to guess!")
            allium.tell("@a", "&6"..tostring(#hangman.incorrect).." incorrect guesses!")
        else
            local test = false
            if args[1]:len() == 1 then
                for i, char in pairs(hangman.letters) do
                    if char.letter == args[1]:sub(1, 1):lower() then
                        hangman.letters[i].guessed = true
                        test = true
                    end
                end
            else
                if args[1] == hangman.word then
                    test = true
                    for _, char in pairs(hangman.letters) do
                        char.guessed = true
                    end
                end
            end
            if test == true then
                allium.tell("@a", name.." &2guessed correctly!")
                local cnt = 0
                for _, char in pairs(hangman.letters) do
                    if char.guessed == true then
                        cnt = cnt+1
                    end
                end
                hangman.guess = ""
                for _, char in pairs(hangman.letters) do
                    if char.guessed == true then
                        hangman.guess = hangman.guess..char.letter.." "
                    else
                        hangman.guess = hangman.guess.."_ "
                    end
                end
                if cnt == #hangman.word then
                    allium.tell("@a", "&2You Won! The word was: &6"..word())
                    hangman.game = false
                end
            else
                hangman.incorrect[#hangman.incorrect+1] = args[1]
                allium.tell("@a", name.." &cguessed incorrectly!")
                if #hangman.incorrect >= 10 then
                    allium.tell("@a", "&cRan out of guesses, game over! The word was: &6"..word())
                    hangman.game = false
                else
                    allium.tell("@a", "&6"..tostring(10-#hangman.incorrect).." guesses left")
                end
            end
            if hangman.game then
                allium.tell("@a", "&1"..hangman.guess)
            else 
                hangman.incorrect = {}
                hangman.guess = ""
                hangman.word = ""
                hangman.letters = {}
            end
        end
    end
end

-- alpha:hangman
this.command("hangman", hangmanGame, info.hangman, "<start | single character, a-z>")

local function mathcmd(name, args)
    local eqn = ""
    for i = 1, #args do
        eqn = eqn..args[i]
    end
    if not eqn:find("function") then
        local ver
        local func = loadstring("return "..eqn)
        if func then
            setfenv(func, {math = math})
            ver, ans = pcall(func)
        else
            ver = false
        end
        if ver then
            allium.tell(name, "&2Answer: &6"..tostring(ans))
        else
            allium.tell(name, "&cNot a valid equation!")
        end
    else
        allium.tell(name, "&cOkay you can stop trying to test the bounds now.")
    end
end

-- alpha:math
this.command("math", mathcmd, info.math, "<equation>")

local function motd(name, args)
    local admins = this.getPersistence(alpha.admins)
    if args[1] == nil then
        if fs.exists("/motd.txt") then
            motd = fs.open("/motd.txt", "r")
            allium.tell(name, motd.readAll(), true)
            motd.close()
        else
            allium.tell(name, "&aWelcome to the server!")
        end
    elseif args[1] == "set" then
        if alpha.isAdmin(name) then
            motd = fs.open("../motd.txt", "w")
            for i = 2, #args do
                motd.write(args[i])
            end
            motd.close()
            allium.tell(name, "&aMoTD set!")
        else
            allium.tell(name, "&cYou do not have permission to use this command.")
        end
    end
end

-- alpha:motd
this.command("motd", motd, info.motd, "[set] [message]")

local function ping(name)
    allium.tell(name, "&aPong!")
end

-- alpha:ping
this.command("ping", ping, info.ping)

local function reboot(name, _, data)
    if alpha.isAdmin(name) then
        allium.tell("@a", "&6Restarting... Please hold all commands until I reboot...")
        os.reboot()
    else
        data.error("You do not have permission to use this command")
    end
end

-- alpha:reboot
this.command("reboot", reboot, info.reboot)

local function rtp(name)
    commands.spreadplayers(20000, 20000, 1000, 20000, false, name)
    allium.tell(name, "&6Teleported to a random location!")
end

-- alpha:rtp
this.command("rtp", rtp, info.rtp)

local function rules(name)
    allium.tell(name, {"&6*&rUse Common Sense", "&6*&rYou are Not a Super Hacker, Don't Hack", "&6*&rRespect All Players", "&6*&rKeep advertising to a minimum", "&6*&rOh and Have Fun!" })
end

-- alpha:rules
this.command("rules", rules, info.rules)

local function sudo(name, args, data)
    if alpha.isAdmin(name) then
        if args[1] ~= nil then
            local players = allium.getPlayers()
            local found = false
            for i = 1, #players do 
                if players[i] == args[1] then
                    found = true
                    break
                end
            end
            if not found then
                data.error("Could not find player "..("" or args[1]))
                return
            end
        else
            data.error()
            return
        end
        if not args[2] then
            data.error()
        else
            local user, command = args[1], args[2]
            table.remove(args, 1)
            table.remove(args, 1)
            local out = table.concat(args, " ")
            if command == "chat" then
                allium.tell("@a", "<"..user.."> "..out, true)
            else
                allium.execute(user, command..out)
            end
        end
    else
        data.error("You do not have permission to run this command")
    end
end

-- alpha:sudo
this.command("sudo", sudo, info.sudo, "<username> <command name | 'chat'> [arguments]")

local function tpa(name, args, data)
    local found = false
    allium.forEachPlayer(function(name)
        if name == args[1] then
            found = true
        end
    end)
    if not found then
        data.error("Player does not exist or is not online.")
    else
        print(allium.tell(args[1], name.." would like to teleport to you, type or click: &6&h[[Click to Teleport]]&g[[!alpha:tpaccept "..name.."]]!tpaccept "..name.."&r to accept"))
        allium.tell(name, "&eSent Teleport Request To: &6"..args[1])
        if alpha.tp_list[args[1]] == nil then
            alpha.tp_list[args[1]] = {}
        end
        alpha.tp_list[args[1]][name] = {name, false}
    end
end

-- alpha:tpa
this.command("tpa", tpa, info.tpa, "<username>")

local function tpaccept(name, args, data)
    if alpha.tp_list[name] ~= nil then
        if alpha.tp_list[name][args[1]] ~= nil then
            allium.tell(name, "&eTeleport request accepted")
            allium.tell(args[1], "&eTeleport request accepted")
            local req = alpha.tp_list[name][args[1]]
            local res
            if not req[2] then
                res = commands.tp(args[1], name)
            else
                res = commands.tp(name, args[1])
            end
            alpha.tp_list[name][args[1]] = nil
            if not res then
                allium.tell(name, "&cTeleport failed, users not in same dimension")
                allium.tell(args[1], "&cTeleport failed, users not in same dimension")
            end
            if not req[2] then
                print("&aTeleported "..args[1].." to "..name)
            else
                print("&aTeleported "..name.." to "..args[1])
            end
        end
    else
        data.error("No Teleport requests at this time")
    end
end

-- alpha:tpaccept
this.command("tpaccept", tpaccept, info.tpaccept)

local function tpahere(name, args, data)
    local found = false
    allium.forEachPlayer(function(name)
        if name == args[1] then
            found = true
        end
    end)
    if not found then
        data.error("Player does not exist or is not online.")
    else
        print(allium.tell(args[1], name.." would like you to teleport to them, type or click: &6&h[[Click to Teleport]]&g[[!alpha:tpaccept "..name.."]]!tpaccept "..name.."&r to accept"))
        allium.tell(name, "&eSent Teleport Request To: &6"..args[1])
        if alpha.tp_list[args[1]] == nil then
            alpha.tp_list[args[1]] = {}
        end
        alpha.tp_list[args[1]][name] = {name, true}
    end
end

-- alpha:tpahere
this.command("tpahere", tpahere, info.tpahere, "<username>")

local function tps(name)
    local _, tps = commands.forge("tps")
    local pos, stp = tps[#tps]:find("TPS: ")
    local tnum = tps[#tps]:sub(stp+1, -1)
    local color = "&a"
    if tonumber(tnum) <= 15 and tonumber(tnum) > 10 then
        color = "&e"
    elseif tonumber(tnum) <= 10 then
        color = "&c"
    end
    allium.tell(name, color..tnum.."&r TPS")
end

-- alpha:tps
this.command("tps", tps, info.tps)

local function warp(name, args, data)
    local persist = this.getPersistence(alpha.warps)
    if persist == nil then
        this.setPersistence(alpha.warps, {})
        persist = {}
    end
    if args[1] ~= "set" and args[1] ~= "list" and args[1] ~= "remove" then
        if persist[args[1]] then
            local location = persist[args[1]]
            local res = commands.tp(name, location.x, location.y, location.z)
            if res then
                allium.tell(name, "&aTeleported to warp&r: &6"..args[1])
            else
                data.error("Warp &6"..args[1].."&c not in same dimension as you")
            end
        else
            data.error("Warp does not exist! Use &6&h[[List Warps]]&g[[!warp list]]!alpha:warp list&r&c for a list of warps")
        end
    elseif args[1] == "list" then
        local warp_str = ""
        for k, _ in pairs(persist) do
            warp_str = warp_str.."\n - &6&h[[Click to teleport to "..k.."]]&g[[!warp "..k.."]]"..k.."&r"
        end
        allium.tell(name, "Warps:"..warp_str)
    elseif args[1] == "set" and alpha.isAdmin(name) then
        if args[2] and not persist[args[2]] then
            local x, y, z = allium.getPosition(name)
            persist[args[2]] = {x = x, y = y, z = z}
            this.setPersistence(alpha.warps, persist)
            allium.tell(name, "Warp &6&h[[Click to Teleport!]]&g[[!warp "..args[2].."]]"..args[2].."&r set!")
        else
            if persist[args[2]] ~= nil then
                data.error("Warp already exists!")
            else
                data.error()
            end
        end
    elseif args[1] == "remove" and alpha.isAdmin(name) then
        if args[2] and persist[args[2]] then
            table.remove(persist, args[2])
            this.setPersistence(alpha.warps, persist)
            allium.tell(name, "Removed warp: &6"..args[2].."!")
        else
            data.error("Warp does not Exist!")
        end
    else
        data.error("You are not admin!")
    end
end

--alpha:warp
-- this.command("warp", warp, info.warp, "<warp name | set | list | remove> [warp name] [x] [y] [z]") Deprecated due to removal of getPosition for 1.11 and 1.12

local function afklock()
    while true do
        local afk = this.getPersistence(alpha.afk)
        if afk then
            for k, v in pairs(afk) do
                local _, res = commands.tp(v[1], v[2], "254", v[4])
            end
        end
        coroutine.yield()
    end
end

this.thread(afklock)

local function login()
    while true do
        local _, name = os.pullEvent("player_join")
        os.queueEvent("chat_capture", "!alpha:motd", "", name)
    end
end

this.thread(login)


--[[local function repeatName(name, message)
    local prefixes = allium.getPersistence("prefixes")
    local nicks = allium.getPersistence("nicknames")
	local rank = betaBot.getLevel(name)+1
    if not prefixes then
        prefixes = { 
			user = {},
			ranks = {
				"&r[&amember&r]",
				"&r[&eVIP&r]",
				"&r[&cadmin&r]",
			}
		}
		allium.setPersistence("prefixes", prefixes)
	end
	if not nicks then
		nicks = {}
		allium.setPersistence("nicknames", nicks)
	end
	local nick = nicks[name] or name
	local prefix = prefixes.user[name] or prefixes.ranks[rank] or ""
	commands.tellraw("@a", color.format(prefix.." &r<"..nick.."&r> "..message))
end]]