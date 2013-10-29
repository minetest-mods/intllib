
-- Support the old multi-load method
intllib = intllib or {}

local strings = {}

local LANG = minetest.setting_get("language") or os.getenv("LANG") or "en"
LANG = LANG:sub(1, 2)

local escapes = {
	["\\"] = "\\",
	["n"]  = "\n",
	["="]  = "=",
}

local function unescape(s)
	return s:gsub("([\\]?)\\(.)", function(slash, what)
		if slash and (slash ~= "") then
			return "\\"..what
		else
			return escapes[what] or what
		end
	end)
end


local function find_eq(s)
	for slashes, pos in s:gmatch("([\\]*)=()") do
		if (slashes:len() % 2) == 0 then
			return pos - 1
		end
	end
end


function load_strings(modname)
	local modpath = minetest.get_modpath(modname)
	local file, err = io.open(modpath.."/locale/"..LANG..".txt", "r")
	if not file then
		return nil
	end
	local strings = {}
	for line in file:lines() do
		line = line:trim()
		if line ~= "" and line:sub(1, 1) ~= "#" then
			local pos = find_eq(line)
			if pos then
				local msgid = unescape(line:sub(1, pos - 1):trim())
				strings[msgid] = unescape(line:sub(pos + 1):trim())
			end
		end
	end
	file:close()
	return strings
end

-- Support the old multi-load method
intllib.getters = intllib.getters or {}

function intllib.Getter(modname)
	modname = modname or minetest.get_current_modname()
	if not intllib.getters[modname] then 
		local msgstr = load_strings(modname) or {}
		intllib.getters[modname] = function (s)
			return msgstr[s] or s
		end
	end
	return intllib.getters[modname]
end

