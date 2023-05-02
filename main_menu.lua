#!/usr/bin/lua

uci = require("uci")
x = uci.cursor()
local config_menu_module = require "config_menu"

local function scandir(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls -h "' .. directory .. '"')
    for filename in pfile:lines() do
        if not filename:match "^.+(%..+)$" then
            i = i + 1
            t[i] = filename
        end
    end
    pfile:close()
    return t
end

local function print_file_names()
    local files = scandir("/etc/config")
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    print("Available config files on your system: ")
    print("--------------------------------------")

    for _, v in ipairs(files) do print(v) end
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
end

local function handleInput(opt)
    local input
    repeat input = io.read() until opt[input]

    return opt[input]()
end

local function enter_config_menu()
    print("Which configs' menu do you want to enter?")
    local input
    repeat input = io.read() until input
    return config_menu_module.enter_menu(input)
end

function _Main_menu()
    print "-------------------------------------------------"
    print "|                UCI Script Menu                |"
    print "-------------------------------------------------"

    print("[1] Print all config file names.")
    print("[2] Enter config file menu.")
    print("[x] Exit script.")

    return handleInput({
        ["1"] = print_file_names,
        ["2"] = enter_config_menu,
        ["x"] = os.exit
    })
end

_Main_menu()
