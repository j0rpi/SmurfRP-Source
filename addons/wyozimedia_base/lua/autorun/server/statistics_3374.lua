hook.Add('Initialize','CH_S_b44bceb935c1ca30c582e5fc10e32a10', function()
	http.Post('http://coderhire.com/api/script-statistics/usage/2968/406/b44bceb935c1ca30c582e5fc10e32a10', {
		port = GetConVarString('hostport'),
		hostname = GetHostName()
	})
end)