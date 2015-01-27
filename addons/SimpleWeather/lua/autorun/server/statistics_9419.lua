hook.Add('Initialize','CH_S_eeabe6cfa6133c834092ced03e73b726', function()
	http.Post('http://coderhire.com/api/script-statistics/usage/8597/822/eeabe6cfa6133c834092ced03e73b726', {
		port = GetConVarString('hostport'),
		hostname = GetHostName()
	})
end)