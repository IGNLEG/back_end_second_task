_Main_menu_utils = {}
local config_menu_module = require "modules/config_menu/config_menu"

function _Main_menu_utils.scandir(directory)
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

function _Main_menu_utils.print_file_names()
    local files = _Main_menu_utils.scandir("/etc/config")
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    print("Available config files on your system: ")
    print("--------------------------------------")

    for k, v in ipairs(files) do print(string.format("[%d] [%s]", k, v)) end
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    return _Main_menu.main_menu()
end

function _Main_menu_utils.enter_config_menu(config_name)
    return config_menu_module.enter_menu(config_name)
end

return _Main_menu_utils
