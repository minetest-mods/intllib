
intllib = intllib or {}

local escapes = {
	["\\"] = "\\",
	["n"]  = "\n",
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

function intllib.load_strings(filename)
	local file, err = io.open(filename, "r")
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
