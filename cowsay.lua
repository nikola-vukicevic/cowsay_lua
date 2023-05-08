-- -----------------------------------------------------------------------------
-- Copyright (c) Nikola Vukićević 2023.
-- -----------------------------------------------------------------------------
function cowsay_padding(s, w)
	local t = ""
	local i = 1
	local d = w - #s
	--
	while i <= d do
		t = t .. " "
		i = i + 1
	end
	--
	return s .. t
end
-- -----------------------------------------------------------------------------
function cowsay_correct_line(s, width)
	local corr = 0
	local last = false
	local left = #s
	--
	if #s < width then
		last = true
	else
		local c = s:sub(left, left)
		while c ~= " " do
			left = left - 1
			corr = corr + 1
			c = s:sub(left, left)
		end
		--
		s    = s:sub(1, left - 1)
		left = left
	end
	--
	s = cowsay_padding(s, width)
	--
	return {
		line = s,
		corr = corr,
		last = last
	}
end
-- -----------------------------------------------------------------------------
function cowsay_format_lines(s)
	local lines = { }
	local width = 56
	local char  = "│"
	local l     = 1
	local r     = width + 1
	--
	if r > #s then
		r = #s
	end
	--
	while l <= #s do
		local t   = s:sub(l, r)
		local res = cowsay_correct_line(t, width)
		t = res.line
		t = char .. " " .. t .. " " .. char
		table.insert(lines, t)
		--
		if res.last == false then
			l = r - res.corr + 1
		else
			l = #s + 1
		end
		--
		r = l + width
		--
		if r > #s then
			r = #s
		end
	end
	--
	return lines
end
-- -----------------------------------------------------------------------------
function cowsay_merge_quote_lines(lines, quote_lines, i)
	for _,line in ipairs(quote_lines) do
		-- print(vim.inspect(line))
		table.insert(lines, i, line)
		i = i + 1
	end
	--
	return i
end
-- -----------------------------------------------------------------------------
function cowsay_get_index(t)
	math.randomseed(os.clock())
	return math.random(1, #t)
end
-- -----------------------------------------------------------------------------
function CowSay()
	local i = 2
	local lines = {
		"╭──────────────────────────────────────────────────────────╮",
		"╰──────────────────────────────────────────────────────────╯",
        "   o                                                        ",
        "    o   ^__^                                                ",
        "     o  (oo)\\_______                                       ",
        "        (__)\\       )\\/\\                                 ",
        "            ||----w |                                       ",
        "            ||     ||                                       ",
	}
	--
	local quotes      = require("cowsay_quotes").quotes
	local index       = cowsay_get_index(quotes)
	local quote       = quotes[index][1]
	local author      = quotes[index][2] 
	local quote_lines = cowsay_format_lines(quote)
	local author_lines
	if author == "" then
		author_lines = { }
	else
		author_lines = cowsay_format_lines("- " .. author)
	end
	--
	i = cowsay_merge_quote_lines(lines, quote_lines, i)
	i = cowsay_merge_quote_lines(lines, author_lines, i)
	--
	return lines
end
-- -----------------------------------------------------------------------------

