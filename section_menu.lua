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
        print(string.format("[%d] : Name: [%s], value: [%s]", i, k, tostring(v)))
    end
    print("[x] : Return to config menu.")
    options["x"] = _Section_menu.section_menu
    repeat input = io.read() until options[input]
    if input == "x" then return options[input]() end
    return options[input]
end

local function edit_option(option_name)
        print("Enter new value for option " .. option_name .. ".")
        local input
        repeat input = io.read() until input
        x:set(config_name, section_name, option_name, input)
        return _Section_menu.section_menu()
end

function _Section_menu.section_menu()
    print "-------------------------------------------------"
    print("       Sections'  \"" .. section_name .. "\"    Menu             ")
    print "-------------------------------------------------"

    print("[1] Set value for an option.")

    return handleInput({["1"] = function() edit_option(select_option()) end})
end

function _Section_menu.enter_menu(config, section)
    config_name = config
    section_name = section
    _Section_menu.section_menu()
end

return _Section_menu
