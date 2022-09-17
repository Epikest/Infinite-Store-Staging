--	To be used with `.github/workflows/pages.yml`

local args = ... or "" --// loadstring(loader.luau)(...)
getgenv().IS = {}
getgenv().IS.options = string.split(args, " ")

getgenv().IS.YAML = getgenv().IS.loadGitHub("api7/lua-tinyyaml", "tinyyaml.lua")
getgenv().IS.SynV3 = syn and DrawingImmediate
getgenv().IS.hUI = get_hidden_gui or gethui

for _, service in ipairs(game:GetChildren()) do
	local success, result = pcall(function()
		getgenv()[service.Name] = game:FindService(service.Name)
	end)
end --// Service:Method()

getgenv().IS.validate = function(chunk)
	local func, err = loadstring(chunk) --// Compile chunk and store return values
	if not func then
		warn(err)
	else
		return true
	end
end --// IS.validate("print(1)") --> true

getgenv().IS.validateLoad = function(chunk, ...)
	local func, err = loadstring(chunk)
	if not func then
		warn(err)
	else
		return func(...) --// Execute chunk with provided varargs
	end
end --// IS.validateLoad("print(args)", "1", "2") --> 1, 2

getgenv().IS.get = function(URL, nocache)
	local methods = {
		["Load"] = function(self, ...)
			loadstring(self())(...)
		end
	}
	return setmetatable(methods, {
		__call = function(self) 
			return game:HttpGetAsync(URL, nocache or false)
		end
	})
end --// IS.get("https://files.com/file"):Load(opts)

getgenv().IS.getGitHub = function(repository, path, nocache)
	local user, repo, branch = string.match(repository, "([^/]+)/([^@]+)@?(.*)")
	--> "User/Repository?@branch"

	assert(user and repo, "Invalid repository format")
	assert(type(path) == "string", "The filepath must be a string")

	-- Set local `branch` to GitHub default if <nil> or empty
	if branch == "" or not branch then
		branch = HttpService:JSONDecode(
			game:HttpGetAsync("https://api.github.com/repos/" .. user .. "/" .. repo)
		).default_branch
	end

	-- Add methods to <string> here
	local methods = {
		["Load"] = function(self, ...)
			loadstring(self())(...)
		end
	}

	if nocache then
		return setmetatable(methods, {
			["__call"] = function(self) 
				return game:HttpGetAsync(
					"https://raw.githubusercontent.com/" .. user .. "/" .. repo .. "/" .. branch .. "/" .. path,
					true
				)
			end
		})
	else
		return setmetatable(methods, {
			["__call"] = function(self)
				return game:HttpGetAsync(
					"https://cdn.jsdelivr.net/gh/" .. user .. "/" .. repo .. "@" .. branch .. "/" .. path
				)
			end
		})
	end
end --// IS.getGitHub("Epikest/something@main", "folder/file.luau", true):Load(opts)

getgenv().IS.getoption = function(option)
	-- Convert table.find result to boolean
	return not (not table.find(IS.options, option))
end --// IS.getoption("dev") --> true

getgenv().IS.switch = function(case, cases)
	return (cases[case] and ((typeof(cases[case]) == "function" and cases[case]()) or cases[case]))
		or (typeof(cases[default]) == "function" and cases[default]())
		or cases[default]
end --// IS.switch(func(), {[true] = "a", [something] = "b", [default] = "c"})

getgenv().IS.art = setmetatable({}, {
	["__call"] = function()
		print("\n" .. IS.art.text)
	end
}
getgenv().IS.art.text = IS.getoption("dev") and [[
^!!~~^.                                                                                                
.:^^!??:  .                         ~7. ^?^       !7. ~JJJJJ?: ^?: :?~       ~?: :?^.7JJJJJJJ7.^JJJJJJ~
	.!J~.^77!!~~^::...             .YB^ 7#BJ:    .5G: ?#?~~~^. ?#~ ~#BY^    .JB^ !#7.^~~J#J~~^.?#?~~~~:
	.~J~. .::^~~!!7777!!~~^^::..   .YG^ !BJYP?:  .5G: ?B~      ?B~ ~BYJPJ:  .JB^ !B7    !B!    ?B!.... 
	 ^?!.          ..::^^~!!!777!. .YG^ !#! ^YP7..5G: ?#5YYY^  ?B~ ~B?.^YP?:.JB^ !B7    !B!    ?#PYYY7.
	 :?7.                    .~?7: .YG^ !#!   ~5P7PG: ?B!:::.  ?B~ ~B?   ~5P?YB^ !B7    !B!    ?B~     
	 :77:                   .~?!:  .YB^ !#!    .!P#G: ?#~      ?#~ ~#?     ~5BB^ !#7    !#7    ?#7^^^^:
	 .!?^                  ^77^.    !?. ^J^      .!?. ~J:      ~?: :J~      .!J: :J^    ^J^    ^YJJJJJ7
	 .!?7!~^^::..        .!?!:                    ^777~..!7!!!!!!~.  :~777!~.    .~!!!^    ~!!!!!!.  N 
	  ^?7!~!!!!77!!!~~^^~77^                    :5P?77J!:!7?5#Y?7!.~Y5J777?YPJ:  !#5?J55~ :GG?7777.  I 
	  .~77!!!~~~~^~~~~!!!~.                     ~#Y:        7B~   7BJ:      ^5G~ !B!  ^B5.:G5.       G 
	 :~7777!~~~!!!!!!!~:                        .!Y5YJ!.    7B!  :G5.        ^BY.!BJ~!YG7 :GBYYYJ^   H 
	.7?^.^77:    .:~7??!.                          .^7PP^   7B!  :5G^        !B?.!BBBP7:  :G5^:::.   T 
	.~?!~!?!.    .~?!^~77:                      ^~:. :YB~   7#!   ^5P7:....^JGJ. !#?755~. :G5:....   L 
	  :^~^:      .!?~^^77:                      ~Y5YY5Y~    !P^    .~JYYYYYY?^   ~P~ .757.:YPYYYYY^  Y 
				  .^~!!~.                         .::.                 .::.             .   ......   ! 
]] or [[
^!!~~^.                                                                                                
.:^^!??:  .                         ~7. ^?^       !7. ~JJJJJ?: ^?: :?~       ~?: :?^.7JJJJJJJ7.^JJJJJJ~
	.!J~.^77!!~~^::...             .YB^ 7#BJ:    .5G: ?#?~~~^. ?#~ ~#BY^    .JB^ !#7.^~~J#J~~^.?#?~~~~:
	.~J~. .::^~~!!7777!!~~^^::..   .YG^ !BJYP?:  .5G: ?B~      ?B~ ~BYJPJ:  .JB^ !B7    !B!    ?B!.... 
	 ^?!.          ..::^^~!!!777!. .YG^ !#! ^YP7..5G: ?#5YYY^  ?B~ ~B?.^YP?:.JB^ !B7    !B!    ?#PYYY7.
	 :?7.                    .~?7: .YG^ !#!   ~5P7PG: ?B!:::.  ?B~ ~B?   ~5P?YB^ !B7    !B!    ?B~     
	 :77:                   .~?!:  .YB^ !#!    .!P#G: ?#~      ?#~ ~#?     ~5BB^ !#7    !#7    ?#7^^^^:
	 .!?^                  ^77^.    !?. ^J^      .!?. ~J:      ~?: :J~      .!J: :J^    ^J^    ^YJJJJJ7
	 .!?7!~^^::..        .!?!:                    ^777~..!7!!!!!!~.  :~777!~.    .~!!!^    ~!!!!!!.    
	  ^?7!~!!!!77!!!~~^^~77^                    :5P?77J!:!7?5#Y?7!.~Y5J777?YPJ:  !#5?J55~ :GG?7777.    
	  .~77!!!~~~~^~~~~!!!~.                     ~#Y:        7B~   7BJ:      ^5G~ !B!  ^B5.:G5.         
	 :~7777!~~~!!!!!!!~:                        .!Y5YJ!.    7B!  :G5.        ^BY.!BJ~!YG7 :GBYYYJ^     
	.7?^.^77:    .:~7??!.                          .^7PP^   7B!  :5G^        !B?.!BBBP7:  :G5^:::.     
	.~?!~!?!.    .~?!^~77:                      ^~:. :YB~   7#!   ^5P7:....^JGJ. !#?755~. :G5:....     
	  :^~^:      .!?~^^77:                      ~Y5YY5Y~    !P^    .~JYYYYYY?^   ~P~ .757.:YPYYYYY^    
				  .^~!!~.                         .::.                 .::.             .   ......     
]]

local switch, getoption, art, getGitHub = IS.switch, IS.getoption, IS.art, IS.getGitHub
switch(getoption("dev"), {
	[true] = function()
		switch(getoption("cache"), {
			[true] = function()
				if isfile(".logservicedetected") then
					switch(getoption("forcelog"), {
						[true] = function()
							warn("Logging enforced")
							warn("Caching enabled")
							art()
						end,
					})
				else
					switch(getoption("forcelog"), {
						[true] = function()
							warn("Logging enforced")
						end,
					})
					warn("Caching enabled")
					art()
				end
				getGitHub("Infinite-Store/Nightly-Store", "main.luau"):Load()
			end,
			[false] = function()
				if isfile(".logservicedetected") then
					switch(getoption("forcelog"), {
						[true] = function()
							warn("Logging enforced")
							warn("Caching disabled")
							art()
						end,
					})
				else
					switch(getoption("forcelog"), {
						[true] = function()
							warn("Logging enforced")
						end,
					})
					warn("Caching disabled")
					art()
				end
				getGitHub("Infinite-Store/Nightly-Store" "main.luau", true):Load()
			end,
		})
	end,
	[false] = function()
		switch(getoption("cache"), {
			[true] = function()
				if isfile(".logservicedetected") then
					switch(getoption("forcelog"), {
						[true] = function()
							warn("Logging enforced")
							warn("Caching enabled")
							art()
						end,
					})
				else
					switch(getoption("forcelog"), {
						[true] = function()
							warn("Logging enforced")
						end,
					})
					warn("Caching enabled")
					art()
				end
				getGitHub("Infinite-Store/Infinite-Store", "main.luau"):Load()
			end,
			[false] = function()
				if isfile(".logservicedetected") then
					switch(getoption("forcelog"), {
						[true] = function()
							warn("Logging enforced")
							warn("Caching disabled")
							art()
						end,
					})
				else
					switch(getoption("forcelog"), {
						[true] = function()
							warn("Logging enforced")
						end,
					})
					warn("Caching disabled")
					art()
				end
				getGitHub("Infinite-Store/Infinite-Store", "main.luau", true):Load()
			end,
		})
	end,
})

if not isfile(".logservicedetected") then
	for _, connection in next, getconnections(LogService.MessageOut) do
		if connection then
			writefile(".logservicedetected", "")
		end
	end
end
