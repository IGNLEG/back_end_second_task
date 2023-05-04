_Section_menu = {}
local section_name
local config_name
local section_menu_utils = require("modules/section_menu/section_menu_utils")

local function handleInput(opt)
    local input
    repeat input = io.read() until opt[input]

    return opt[input]()
end

local function select_option()
    print("Select option:")
    local input, i, options = nil, 0, {}
    local status, value = pcall(x.get_all, x ,config_name, section_name)
    if not status then 
        print("Error:" .. value .. " while getting option list.") 
        return _Section_menu.section_menu() 
    end
    for k, v in pairs(value) do
        i = i + 1
        options[tostring(i)] = k
        if type(v) == "table" then
            print(string.format("[%d] : Name: [%s], values: ", i, k))
            for s, w in pairs(v) do print(s, w) end
        else
            print(string.format("[%d] : Name: [%s], value: [%s]", i, k,
                                tostring(v)))
        end
    end

    print("[x] : Return to section menu.")
    options["x"] = _Section_menu.section_menu
    repeat input = io.read() until options[input]
    if input == "x" then return options[input]() end
    return options[input]
end

local function set_option_input(option_name, replace)
    local status, values = pcall(x.get, x, config_name, section_name, option_name)
    if not status or replace then values = {} end
    local input
    print("Enter new value(s) for option " .. option_name .. " (type 'x' or leave blank to finish):")
    repeat
        input = io.read()
        if (input ~= "" and input ~= "x") then
            table.insert(values, input)
        end
    until input == "" or input == "x"
    return option_name, values
end

local function create_option_name_input()
    print("Enter option name: ")
    local input
    repeat input = io.read() until input ~= ""
    return set_option_input(input, true)
end

function _Section_menu.section_menu()
    print "-------------------------------------------------"
    print("       Sections'  \"" .. section_name .. "\"    Menu             ")
    print "-------------------------------------------------"

    print("[1] Set value(s) for an existing option (adds values if option is a list - use create to replace values).")
    print("[2] Create new option (overwrites existing one's, with same name, values).")
    print("[3] Delete option.")
    print("[x] Return to config menu.")

    return handleInput({
        ["1"] = function()
            local opt_n, val = set_option_input(select_option())
            section_menu_utils.set_option(config_name, section_name, opt_n, val)
        end,
        ["2"] = function()
            local opt_n, val = create_option_name_input()
            section_menu_utils.set_option(config_name, section_name, opt_n, val)
        end,
        ["3"] = function()
            section_menu_utils.delete_option(config_name, section_name,
                                             select_option())
        end,
        ["x"] = function() _Config_menu.config_menu() end
    })
end

function _Section_menu.enter_menu(config, section)
    config_name = config
    section_name = section
    _Section_menu.section_menu()
end

return _Section_menu
