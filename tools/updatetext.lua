#! /usr/bin/env lua

local basedir = ""
if arg[0]:find("[/\\]") then
	basedir = arg[0]:gsub("(.*[/\\]).*$", "%1"):gsub("\\", "/")
end
if basedir == "" then basedir = "./" end

-- Required by load_strings()
function string.trim(s) -- luacheck: ignore
	return s:gsub("^%s*(.-)%s*$", "%1")
end

dofile(basedir.."/../lib.lua")

local me = arg[0]:gsub(".*[/\\](.*)$", "%1")

local function err(fmt, ...)
	io.stderr:write(("%s: %s\n"):format(me, fmt:format(...)))
	os.exit(1)
end

local output, outfile, template
local catalogs = { }

local function usage()
	print([[
Usage: ]]..me..[[ [OPTIONS] TEMPLATE CATALOG...

Update a catalog with new strings from a template.

Available options:
  -h,--help         Show this help screen and exit.
  -o,--output X     Set output file (default: stdout).

Messages in the template that are not on the catalog are added to the
catalog at the end.

This tool also checks messages that are in the catalog but not in the
template, and reports such lines. It's up to the user to remove such
lines, if so desired.
]])
	os.exit(0)
end

local i = 1

while i <= #arg do
	local a = arg[i]
	if (a == "-h") or (a == "--help") then
		usage()
	elseif (a == "-o") or (a == "--output") then
		i = i + 1
		if i > #arg then
			err("missing required argument to `%s'", a)
		end
		output = arg[i]
	elseif a:sub(1, 1) ~= "-" then
		if not template then
			template = a
		else
			table.insert(catalogs, a)
		end
	else
		err("unrecognized option `%s'", a)
	end
	i = i + 1
end

if not template then
	err("no template specified")
elseif #catalogs == 0 then
	err("no catalogs specified")
end

local f, e = io.open(template, "r")
if not f then
	err("error opening template: %s", e)
end

local escapes = { ["\n"] = "\\n", ["="] = "\\=", ["\\"] = "\\\\", }
local function escape(s)
	return s:gsub("[\\\n=]", escapes)
end

if output then
	outfile, e = io.open(output, "w")
	if not outfile then
		err("error opening file for writing: %s", e)
	end
end

local template_msgs = intllib.load_strings(template)

for _, file in ipairs(catalogs) do
	print("Processing: "..file)
	local catalog_msgs = intllib.load_strings(file)
	local dirty_lines = { }
	if catalog_msgs then
		-- Add new entries from template.
		for k in pairs(template_msgs) do
			if not catalog_msgs[k] then
				print("NEW: "..k)
				table.insert(dirty_lines, escape(k).." =")
			end
		end
		-- Check for old messages.
		for k, v in pairs(catalog_msgs) do
			if not template_msgs[k] then
				print("OLD: "..k)
				table.insert(dirty_lines, "OLD: "..escape(k).." = "..escape(v))
			end
		end
		if #dirty_lines > 0 then
			local outf
			outf, e = io.open(file, "a+")
			if outf then
				outf:write("\n")
				for _, line in ipairs(dirty_lines) do
					outf:write(line)
					outf:write("\n")
				end
				outf:close()
			else
				io.stderr:write(("%s: WARNING: cannot write: %s\n"):format(me, e))
			end
		end
	else
		io.stderr:write(("%s: WARNING: could not load catalog\n"):format(me))
	end
end
