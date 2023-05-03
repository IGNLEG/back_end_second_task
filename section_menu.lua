_Section_menu = {}
local section_name
local config_name

local function handleInput(opt)
    local input
    repeat input = io.read() until opt[input]

    return opt[input]()
end

local function select_option()
    print("Select option:")
    local input, i, options = nil, 0, {}
    for k, v in pairs(x:get_all(config_name, section_name)) do
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

local function set_list_option(option_name)
    local status, info = pcall(x:get(config_name, section_name, option_name))
    if not status then info = {} end
    local input
    repeat
        print("Enter new values for option " .. option_name .. ":")
        input = io.read()
        if (input ~= "") then table.insert(info, input) end
    until input == ""
    x:set(config_name, section_name, option_name, info)
    return _Section_menu.section_menu()
end

local function set_option(option_name)
    local status, value = pcall(x:get(config_name, section_name, option_name))
    if status and type(value) == "table" then
        return set_list_option(option_name)
    end
    print("Enter new value for option " .. option_name .. ":")
    local input
    repeat input = io.read() until input
    x:set(config_name, section_name, option_name, input)
    return _Section_menu.section_menu()
end

local function create_list_option()
    print("Enter option name: ")
    local input
    repeat input = io.read() until input ~= ""
    return (set_list_option(input))
end
local function create_option()
    print("Enter option name: ")
    local input
    repeat input = io.read() until input ~= ""
    return (set_option(input))
end
local function delete_option(option_name)
    x:delete(config_name, section_name, option_name)
    return _Section_menu.section_menu()
end
function _Section_menu.section_menu()
    print "-------------------------------------------------"
    print("       Sections'  \"" .. section_name .. "\"    Menu             ")
    print "-------------------------------------------------"

    print("[1] Set value(s) for an existing option.")
    print("[2] Create new option (overwrites existing one with same name).")
    print("[3] Create new list option (overwrites existing one with same name).")
    print("[4] Delete option.")
    print("[x] Return to config menu.")

    return handleInput({
        ["1"] = function() set_option(select_option()) end,
        ["2"] = create_option,
        ["3"] = create_list_option,
        ["4"] = function() delete_option(select_option()) end,
        ["x"] = function() _Config_menu.config_menu() end
    })
end

function _Section_menu.enter_menu(config, section)
    config_name = config
    section_name = section
    _Section_menu.section_menu()
end

return _Section_menu
