
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

local function do_load_strings ( f )
    local msgstr = { };
    for line in f:lines() do
        line = line:trim();
        if ((line ~= "") and (line:sub(1, 1) ~= "#")) then
            local pos = line:find("=", 1, true);
            if (pos) then
                local msgid = line:sub(1, pos - 1):trim();
                msgstr[msgid] = line:sub(pos + 1):trim();
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
            return nil;
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
