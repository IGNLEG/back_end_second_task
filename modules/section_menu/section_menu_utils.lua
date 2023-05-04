_Section_menu_utils = {}

function _Section_menu_utils.set_option(config_name, section_name, option_name, value)
    if value ~= "" and value ~= "x" and value ~= nil then
        x:set(config_name, section_name, option_name, value)
    end
    return _Section_menu.section_menu()
end

function _Section_menu_utils.delete_option(config_name, section_name,
                                           option_name)
    x:delete(config_name, section_name, option_name)
    return _Section_menu.section_menu()
end

return _Section_menu_utils
