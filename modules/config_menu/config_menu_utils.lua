_Config_menu_utils = {}
local section_menu_module = require("modules/section_menu/section_menu")

function _Config_menu_utils.print_config(config_name)
    local status, value = pcall(x.get_all, x, config_name)
    if not status then 
        print ("Error: " .. value .. " while getting config sections.") 
        return _Config_menu.config_menu() 
    end
    for _, v in pairs(value) do
        print("--------------------------------------")
        for k, w in pairs(v) do
            if (type(w) == "table") then
                for _, s in pairs(w) do print(k, s) end
            else
                print(k, w)
            end
        end
    end
    return _Config_menu.config_menu()
end

function _Config_menu_utils.create_section(section_name, section_type, config_name)
    print(section_name, section_type)
    if section_name ~= "" then
        x:set(config_name, section_name, section_type)
    else
        x:add(config_name, section_type)
    end
    return _Config_menu.config_menu()
end

function _Config_menu_utils.print_section(section_name, config_name)
    for k, v in pairs(x:get_all(config_name, section_name)) do
        if (type(v) == "table") then
            for _, w in pairs(v) do print(k, w) end
        else
            print(k, v)
        end
    end
    return _Config_menu.config_menu()
end

function _Config_menu_utils.delete_section(section_name, config_name)
    x:delete(config_name, section_name)
    return _Config_menu.config_menu()
end

function _Config_menu_utils.enter_section_menu(config_name, section_name)
        return section_menu_module.enter_menu(config_name, section_name)
end
return _Config_menu_utils
