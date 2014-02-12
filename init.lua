
-- Support the old multi-load method
intllib = intllib or {}

local MP = minetest.get_modpath("intllib")

dofile(MP.."/lib.lua")

local strings = {}

local LANG = minetest.setting_get("language")
if not (LANG and (LANG ~= "")) then LANG = os.getenv("LANG") end
if not (LANG and (LANG ~= "")) then LANG = "en" end
LANG = LANG:sub(1, 2)

-- Support the old multi-load method
intllib.getters = intllib.getters or {}

intllib.strings = {}

local function noop_getter(s)
	return s
end

function intllib.Getter(modname)
	modname = modname or minetest.get_current_modname()
	if not intllib.getters[modname] then 
		local modpath = minetest.get_modpath(modname)
		if modpath then
			local filename = modpath.."/locale/"..LANG..".txt"
			local msgstr = intllib.load_strings(filename)
			intllib.strings[modname] = msgstr or false
			if msgstr then
				intllib.getters[modname] = function (s)
					if msgstr[s] and msgstr[s] ~= "" then
						return msgstr[s]
					end
					return s
				end
			else
				intllib.getters[modname] = noop_getter
			end
		end
	end
	return intllib.getters[modname]
end

function intllib.get_strings(modname)
	modname = modname or minetest.get_current_modname()
	local msgstr = intllib.strings[modname]
	if msgstr == nil then
		local modpath = minetest.get_modpath(modname)
		msgstr = intllib.load_strings(modpath.."/locale/"..LANG..".txt")
		intllib.strings[modname] = msgstr
	end
	return msgstr or nil
end

