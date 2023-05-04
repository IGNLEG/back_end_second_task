_Config_menu = {}
local config_name
local config_menu_utils = require("modules/config_menu/config_menu_utils")
function _Config_menu.select_section()
    print("Select section:")
    local input, i, options = nil, 0, {}
    for _, v in pairs(x:get_all(config_name)) do
        i = i + 1
        options[tostring(i)] = v[".name"]
        print(string.format("[%d] : [%s]", i, v[".name"]))
    end

    print("[x] : Return to config menu.")
    options["x"] = _Config_menu.config_menu
    repeat input = io.read() until options[input]
    if input == "x" then return options[input]() end
    return options[input]
end

function _Config_menu.handleInput(opt)
    local input
    repeat input = io.read() until opt[input]

    return opt[input]()
end

function _Config_menu.create_section_input()
    local section_name, section_type
    print("Enter section name (leave blank for anonymous section): ")
    repeat section_name = io.read() until section_name
    print("Enter section type:")
    repeat section_type = io.read() until section_type ~= ""
    return section_name, section_type
end

function _Config_menu.config_menu()
    print "-------------------------------------------------"
    print("         Configs'  \"" .. config_name .. "\"    Menu             ")
    print "-------------------------------------------------"

    print("[1] Print config contents.")
    print("[2] Print a sections value.")
    print("[3] Create a new section.")
    print("[4] Delete section.")
    print("[5] Enter a sections menu.")
    print("[6] Discard all changes that are not yet commited.")
    print("[7] Commit changes to config.")
    print("[x] Return to main menu.")

    return _Config_menu.handleInput({
        ["1"] = function() config_menu_utils.print_config(config_name) end,
        ["2"] = function()
            config_menu_utils.print_section(_Config_menu.select_section(), config_name)
        end,
        ["3"] = function()
            local sc_n, sc_t = _Config_menu.create_section_input()
            config_menu_utils.create_section(
                sc_n, sc_t, config_name)
        end,
        ["4"] = function()
            config_menu_utils.delete_section(_Config_menu.select_section(),
                                             config_name)
        end,
        ["5"] = function()
            config_menu_utils.enter_section_menu(config_name,
                                         _Config_menu.select_section())
        end,
        ["6"] = function()
            x:revert(config_name)
            return _Config_menu.config_menu()
        end,
        ["7"] = function()
            x:commit(config_name)
            return _Config_menu.config_menu()
        end,
        ["x"] = _Main_menu.main_menu
    })
end

function _Config_menu.enter_menu(config)
    config_name = config
    _Config_menu.config_menu()
end

return _Config_menu
