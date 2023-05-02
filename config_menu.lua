local section_menu_module = require("section_menu")

_Config_menu = {}
local config_name

local function print_config()
    for _, v in pairs(x:get_all(config_name)) do
        print("--------------------------------------")
        for k, w in pairs(v) do print(k, w) end
    end
    return _Config_menu.config_menu()
end

local function handleInput(opt)
    local input
    repeat input = io.read() until opt[input]

    return opt[input]()
end

local function select_section()
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

local function create_section()
    local section_name, section_type
    print("Enter section name (leave blank for anonymous section): ")
    repeat section_name = io.read() until section_name
    print("Enter section type:")
    repeat section_type = io.read() until section_type ~= ""

    if section_name ~= "" then
        x:set(config_name, section_name, section_type)
    else
        x:add(config_name, section_type)
    end
    return _Config_menu.config_menu()
end

local function print_section(section_name)
    for k, v in pairs(x:get_all(config_name, section_name)) do
        if (type(v) == "table") then
            for _, w in pairs(v) do print(k, w) end
        else
            print(k, v)
        end
    end
    return _Config_menu.config_menu()
end

local function delete_section(section_name)
    x:delete(config_name, section_name)
    return _Config_menu.config_menu()
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
    --     print("[6] Discard all changes that are not yet commited.")
    --     print("[7] Commit changes to config.")
    print("[x] Return to main menu.")

    return handleInput({
        ["1"] = print_config,
        ["2"] = function() print_section(select_section()) end,
        ["3"] = create_section,
        ["4"] = function() delete_section(select_section()) end,
        ["5"] = function() section_menu_module.enter_menu(config_name, select_section()) end,
        -- ["6"] = x:revert(config_name),
        -- ["7"] = x:commit(config_name),
        ["x"] = _Main_menu
    })
end

function _Config_menu.enter_menu(config)
    config_name = config
    _Config_menu.config_menu()
end

return _Config_menu
