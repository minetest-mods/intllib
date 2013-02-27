#! /usr/bin/env lua

local function listdir ( dir )
    local LS;
    if (os.getenv("WINDIR")) then
        LS = 'dir /b %s';
    else
        LS = 'ls %s';
    end
    local tmp = os.tmpname();
    local r = os.execute(LS:format(dir).." > "..tmp)
    if ((r ~= nil) and (r == 0)) then
        local list = { };
        local f = io.open(tmp);
        if (not f) then
            os.remove(tmp);
            return nil;
        end
        for line in f:lines() do
            list[#list + 1] = line;
        end
        f:close();
        os.remove(tmp);
        return list;
    end
    os.remove(tmp);
    return nil;
end

local function StringOutput ( s, file )
    return {
        _buf = (s or "");
        _file = file;
        write = function ( self, ... )
            local spc = false;
            for _, v in ipairs({...}) do
                if (spc) then self._buf = self._buf.." "; end
                spc = true;
                self._buf = self._buf..tostring(v);
            end
        end;
        print = function ( self, ... )
            local spc = false;
            for _, v in ipairs({...}) do
                if (spc) then self._buf = self._buf.." "; end
                spc = true;
                self._buf = self._buf..tostring(v);
            end
            self._buf = self._buf.."\n";
        end;
        tostring = function ( self )
            return self._buf;
        end;
        flush = function ( self, file )
            local f = (file or self._file or io.stdout);
            f:write(self._buf);
            f:flush();
        end;
    };
end

local function err_print ( s )
    io.stderr:write((s or "").."\n");
end

local function ArgParser ( appname, usageline, description )
    return {
        prefix = ((appname and (appname..": ")) or "");
        description = description;
        options = {
            { name = "help";
              short = "h";
              long = "help";
              help = "Show this help screen and exit.";
            },
        };
        values = { };
        inputs = { };
        no_exit = (appname == nil);
        add_option = function ( self, name, short, long, has_arg, arg_name, help )
            self.options[#self.options+1] = {
                name = name;
                short = short;
                long = long;
                has_arg = has_arg;
                arg_name = arg_name;
                help = help;
            };
        end;
        parse = function ( self, args, no_exit )
            local opts = { };
            local inputs = { };
            local i = 1;
            while (i <= #args) do
                local a = args[i];
                if (a:sub(1, 1) == '-') then
                    local found = false;
                    if ((a == "-h") or (a == "--help")) then
                        if (no_exit or self.no_exit) then
                            return nil, "--help";
                        else
                            self:show_usage();
                            os.exit(0);
                        end
                    end
                    for _, opt in ipairs(self.options) do
                        if ((a == "-"..opt.short) or (a == "--"..opt.long)) then
                            if (opt.has_arg) then
                                i = i + 1;
                                if (not args[i]) then
                                    local msg = self.prefix.."option `"..a.."' requires an argument."; 
                                    if (no_exit) then
                                        return nil, msg;
                                    else
                                        err_print(msg);
                                        os.exit(-1);
                                    end
                                end
                                opts[opt.name] = args[i];
                            else
                                opts[opt.name] = true;
                            end
                            found = true;
                            break;
                        end
                    end
                    if (not found) then
                        local msg = self.prefix.."unrecognized option `"..a.."'. Try `--help'.";
                        if (no_exit or self.no_exit) then
                            return nil, msg;
                        else
                            err_print(msg);
                            os.exit(-1);
                        end
                    end
                else
                    inputs[#inputs + 1] = a;
                end
                i = i + 1;
            end
            return opts, inputs;
        end;
        show_usage = function ( self, extramsg )
            if (extramsg) then
                err_print(self.prefix..extramsg);
            end
            err_print("Usage: "..appname.." "..(usageline or ""));
            if (self.description) then
                err_print(self.description)
            end
            if (#self.options > 0) then
                err_print("\nAvailable Options:");
                local optwidth = 0;
                local optline = { };
                for _, opt in ipairs(self.options) do
                    local sh = (opt.short and "-"..opt.short);
                    local ln = (opt.long and "--"..opt.long);
                    local sep = (sh and ln and ",") or " ";
                    sh = sh or "";
                    ln = ln or "";
                    if (opt.long and opt.has_arg) then
                        ln = ln.." "..opt.arg_name;
                    end
                    optline[#optline + 1] = sh..sep..ln;
                    if (optline[#optline]:len() > optwidth) then
                        optwidth = optline[#optline]:len();
                    end
                end
                for i, opt in ipairs(self.options) do
                    local sep = string.rep(" ", optwidth - optline[i]:len()).."  ";
                    err_print("  "..optline[i]..sep..opt.help);
                end
                err_print();
                if (self.footer) then
                    err_print(self.footer.."\n");
                end
            end
        end;
    };
end

local function main ( arg )
    
    local APPNAME = "findtext.lua";
    
    local ap = ArgParser(APPNAME, "[OPTIONS] FILES...");
    ap:add_option("output", "o", "output", true, "FILE", "Write translated strings to FILE. (default: stdout)");
    ap:add_option("langname", "l", "langname", true, "NAME", "Set the language name to NAME.");
    ap:add_option("author", "a", "author", true, "NAME", "Set the author to NAME.");
    ap:add_option("mail", "m", "mail", true, "EMAIL", "Set the author contact address to EMAIL.");
    ap.description = "Finds all the strings that need to be localized, by"..
      " searching for things\n like `S(\"foobar\")'.";
    ap.footer = "Report bugs to <lkaezadl3@gmail.com>.";
    
    local opts, files = ap:parse(arg);
    
    if (#files == 0) then
        files = listdir("*.lua");
        if ((not files) or (#files == 0)) then
            io.stderr:write(APPNAME..": no input files\n");
            os.exit(-1);
        end
    end
    
    local buffer = StringOutput();
    
    buffer:write("\n");
    
    if (opts.langname) then
        buffer:write("# Language: "..opts.langname.."\n");
    end
    if (opts.author) then
        buffer:write("# Author: "..opts.author);
        if (opts.mail) then
            buffer:write(" <"..opts.mail..">");
        end
        buffer:write("\n");
    end
    if (opts.author or opts.langname) then
        buffer:write("\n");
    end
    
    for _, file in ipairs(files) do
        local infile, e = io.open(file);
        if (not infile) then
            io.stderr:write(APPNAME..": "..e.."\n");
            os.exit(1);
        end
        for line in infile:lines() do
            local s = line:match('.-S%("([^"]*)"%).*');
            if (s) then
                buffer:write(s.." = \n");
            end
        end
        infile:close();
    end
    
    local outfile, e;
    if (opts.output) then
        outfile, e = io.open(opts.output, "w");
        if (not outfile) then
            io.stderr:write(APPNAME..": "..e.."\n");
            os.exit(1);
        end
    else
        outfile = io.stdout;
    end
    
    buffer:flush(outfile);
    
    if (outfile ~= io.stdout) then
        outfile:close();
    end

end

main(arg);
