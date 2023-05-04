_Section_menu_utils = {}

function _Section_menu_utils.set_option(config_name, section_name, option_name, value)
    if value ~= "" and value ~= "x" and value ~= nil then
        local status, value = pcall(x.set, x, config_name, section_name, option_name, value)
        if not status then
            print("Error: " .. value .." while adding/setting values for option " .. option_name .. ".")
        end
    else
        print("You can't set an empty value!")
    end
    return _Section_menu.section_menu()
end

function _Section_menu_utils.delete_option(config_name, section_name, option_name)
    local status, value = pcall(x.delete, x, config_name, section_name, option_name)
    if not status then 
             print("Error: " .. value .." while deleting option " .. option_name .. ".")
    end
    return _Section_menu.section_menu()
end

return _Section_menu_utils
