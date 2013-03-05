
intllib = { };

local strings = { };

local INTLLIB_DEBUG = true;

local LANG = minetest.setting_get("language") or os.getenv("LANG") or "en";
LANG = LANG:sub(1, 2);

local TRACE;

if (INTLLIB_DEBUG) then
    TRACE = function ( s )
        print("*** DEBUG: "..s);
    end
else
    TRACE = function ( ) end
end

local repr2esc = {
    ["n"] = "\n";
    ["r"] = "";
    ["t"] = "\t";
    ["\\"] = "\\";
    ["\""] = "\"";
};

local esc2repr = {
    ["\n"] = "\\n";
    ["\r"] = "";
    ["\t"] = "\\t";
    ["\\"] = "\\\\";
    ["\\\""] = "\"";
};

local function parse ( s )
    return s:gsub("\\([nrt\"\'\\\\])", function ( c )
        return (repr2esc[c] or c);
    end);
end

local function repr ( s )
    return s:gsub("[\n\t\"\'\\\\]", function ( c )
        return (esc2repr[c] or c);
    end);
end

local function do_load_strings ( f )
    local msgstr = { };
    for line in f:lines() do
        line = line:trim();
        if ((line ~= "") and (line:sub(1, 1) ~= "#")) then
            local pos = line:find("=", 1, true);
            while (pos and (line:sub(pos - 1, pos - 1) == "\\")) do
                local pos = line:find("=", pos + 1, true);
            end
            if (pos) then
                local msgid = line:sub(1, pos - 1):trim();
                local str = line:sub(pos + 1):trim();
                msgstr[msgid] = parse(str);
            end
        end
    end
    return msgstr;
end

function load_strings ( modname, lang )
    lang = lang or LANG;
    local f, e = io.open(minetest.get_modpath(modname).."/locale/"..lang..".txt");
    if (not f) then
        f, e = io.open(minetest.get_modpath("intllib").."/locale/"..modname.."/"..lang..".txt");
        if (not f) then
            return nil, "Could not load '"..LANG.."' texts: "..e;
        end
    end
    local strings;
    strings = do_load_strings(f);
    f:close();
    return strings;
end

local getters = { };

function intllib.Getter ( modname )
    if (not modname) then modname = minetest.get_current_modname(); end
    if (not getters[modname]) then 
        local msgstr = load_strings(modname, lang) or { };
        getters[modname] = function ( s )
            return msgstr[repr(s)] or s;
        end;
    end
    return getters[modname];
end

function intllib.get_current_language ( )
    return LANG;
end
