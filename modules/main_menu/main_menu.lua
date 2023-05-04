#!/usr/bin/lua

_Main_menu = {}

local main_menu_utils = require "modules/main_menu/main_menu_utils"

function _Main_menu.select_config()
    print("Select config:")
    local files = _Main_menu_utils.scandir("/etc/config")
    local input, options = nil, {}
    for k, v in ipairs(files) do
        options[tostring(k)] = v
        print(string.format("[%d] : [%s]", k, v))
    end

    print("[x] : Return to main menu.")
    options["x"] = _Main_menu.main_menu
    repeat input = io.read() until options[input]
    if input == "x" then return options[input]() end
    return options[input]
end

function _Main_menu.handleInput(opt)
    local input
    repeat input = io.read() until opt[input]

    return opt[input]()
end

function _Main_menu.main_menu()
    print "-------------------------------------------------"
    print "|                UCI Script Menu                |"
    print "-------------------------------------------------"

    print("[1] Print all config file names.")
    print("[2] Enter config file menu.")
    print("[x] Exit script.")

    return _Main_menu.handleInput({
        ["1"] = main_menu_utils.print_file_names,
        ["2"] = function()
            main_menu_utils.enter_config_menu(_Main_menu.select_config())
        end,
        ["x"] = os.exit
    })
end

return _Main_menu
