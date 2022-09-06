-- To be used with .github/workflows/pages.yml

local args = ... or "" --// loadstring(loader.luau)(...)
getgenv().IS = {}
getgenv().IS.options = string.split(args, " ")
getgenv().IS.getoption = function(option)
	return not (not table.find(IS.options, option))
end --// IS.getoption("dev") --> true

setmetatable(getgenv(), {
	__index = function(self, property)
		local success, service = pcall(game.FindService, game, property)
		if success then
			self.property = cloneref and cloneref(service) or service
			return service
		end
	end,
}) --// Service:Method()

getgenv().IS.get = function(URL, nocache)
	return game:HttpGetAsync(URL, nocache or false)
end --// local file = IS.get("https://files.com/file")

getgenv().IS.getGitHub = function(repository, path, nocache)
	local user, repo, branch = string.match(repository, "([^/]+)/([^@]+)@?(.*)")
	assert(user and repo, "Invalid repository format")
	assert(type(path) == "string", "The filepath must be a string")
	if branch == "" or not branch then
		branch = HttpService:JSONDecode(
			game:HttpGetAsync("https://api.github.com/repos/" .. user .. "/" .. repo)
		).default_branch
	end
	local Load = function(varargs)
		loadstring(self)(varargs)
	end
	if nocache then
		return{
			function() game:HttpGetAsync(
				"https://raw.githubusercontent.com/" .. user .. "/" .. repo .. "/" .. branch .. "/" .. path,
				true
			end),
			["Load"] = Load
		}
	else
		return{
			function() game:HttpGetAsync(
				"https://cdn.jsdelivr.net/gh/" .. user .. "/" .. repo .. "@" .. branch .. "/" .. path
			end),
			["Load"] = Load
		}
	}
	end
end --// loadstring(IS.getGitHub("Epikest/something@main", "folder/file.luau", true))()
















-- pain
getgenv().IS.getGitHub = function(repository, path, nocache)
	local user, repo, branch = string.match(repository, "([^/]+)/([^@]+)@?(.*)")
	assert(user and repo, "Invalid repository format")
	assert(type(path) == "string", "The filepath must be a string")
	if branch == "" or not branch then
		branch = HttpService:JSONDecode(
			game:HttpGetAsync("https://api.github.com/repos/" .. user .. "/" .. repo)
		).default_branch
	end
	local Load = function(self)
		loadstring(self.
	end
	if nocache then
		return game:HttpGetAsync(
			"https://raw.githubusercontent.com/" .. user .. "/" .. repo .. "/" .. branch .. "/" .. path,
			true
		)
	else
		return game:HttpGetAsync(
			"https://cdn.jsdelivr.net/gh/" .. user .. "/" .. repo .. "@" .. branch .. "/" .. path
		)
	}
	end
end --// local file = IS.getGitHub("Epikest/something@main", "folder/file.luau", true)

function IS.getGitHub(repository, path, nocache):Load(varargs)
	return loadstring(IS.getGitHub(repository, path, nocache))(varargs)
end --// IS.getGitHub("Epikest/something@main", "folder/file.luau", true):Load()














getgenv().IS.switch = function(case, cases)
	return (cases[case] and ((typeof(cases[case]) == "function" and cases[case]()) or cases[case]))
		or (typeof(cases[default]) == "function" and cases[default]())
		or cases[default]
end --// IS.switch(func(), {[true] = "a", [something] = "b", [default] = "c"})

getgenv().IS.art = function()
	print([[\n
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
\n]])
end
getgenv().IS.artNightly = function()
	print([[\n
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
\n]])
end

switch(IS.getoption("dev"), {
	[true] = function()
		switch(IS.getoption("cache"), {
			[true] = function()
				if isfile(".logservicedetected") then
					switch(IS.getoption("forcelog"), {
						[true] = function()
							warn("Logging enforced")
							warn("Caching enabled")
							IS.artNightly()
						end,
					})
				else
					switch(IS.getoption("forcelog"), {
						[true] = function()
							warn("Logging enforced")
						end,
					})
					warn("Caching enabled")
					IS.artNightly()
				end
				loadstring(IS.getGitHub("Infinite-Store", "Nightly-Store", "dev", "main.luau"))()
			end,
			[false] = function()
				if isfile(".logservicedetected") then
					switch(IS.getoption("forcelog"), {
						[true] = function()
							warn("Logging enforced")
							warn("Caching disabled")
							IS.artNightly()
						end,
					})
				else
					switch(IS.getoption("forcelog"), {
						[true] = function()
							warn("Logging enforced")
						end,
					})
					warn("Caching disabled")
					IS.artNightly()
				end
				loadstring(IS.getGitHub("Infinite-Store/Nightly-Store", "dev" "main.luau", true))()
			end,
		})
	end,
	[false] = function()
		switch(IS.getoption("cache"), {
			[true] = function()
				if isfile(".logservicedetected") then
					switch(IS.getoption("forcelog"), {
						[true] = function()
							warn("Logging enforced")
							warn("Caching enabled")
							IS.art()
						end,
					})
				else
					switch(IS.getoption("forcelog"), {
						[true] = function()
							warn("Logging enforced")
						end,
					})
					warn("Caching enabled")
					IS.art()
				end
				IS.loadGitHub("Infinite-Store", "Infinite-Store", "main", "main.luau")
			end,
			[false] = function()
				if isfile(".logservicedetected") then
					switch(IS.getoption("forcelog"), {
						[true] = function()
							warn("Logging enforced")
							warn("Caching disabled")
							IS.art()
						end,
					})
				else
					switch(IS.getoption("forcelog"), {
						[true] = function()
							warn("Logging enforced")
						end,
					})
					warn("Caching disabled")
					IS.art()
				end
				loadstring(IS.getGitHub("Infinite-Store/Infinite-Store", "main", "main.luau", true))()
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
