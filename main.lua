#!/usr/bin/lua
local main_menu_module = require("modules/main_menu/main_menu")

uci = require("uci")
x = uci.cursor()

main_menu_module.main_menu()