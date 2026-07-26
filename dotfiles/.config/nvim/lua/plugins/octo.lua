return {
	"pwntester/octo.nvim",
	cmd = "Octo",
	opts = {
		picker = "fzf-lua",
		enable_builtin = true,
	},
	keys = {
		{
			"<leader>oi",
			"<CMD>Octo issue list<CR>",
			desc = "List GitHub Issues",
		},
		{
			-- Octo's own PR list only shows number + title: its GraphQL query never
			-- fetches author/createdAt/reviewRequests. Go via `gh` to get them.
			"<leader>op",
			function()
				local fzf = require("fzf-lua")
				local fields = "number,title,author,createdAt,reviewRequests,assignees,isDraft"

				local function format_pr(pr)
					local who = {}
					for _, r in ipairs(pr.reviewRequests or {}) do
						table.insert(who, r.login or r.slug or r.name or "?")
					end
					for _, a in ipairs(pr.assignees or {}) do
						table.insert(who, "@" .. (a.login or "?"))
					end
					return table.concat({
						string.format("%-6s", pr.number),
						pr.isDraft and "○" or "●",
						(pr.createdAt or ""):sub(1, 10),
						string.format("%-18s", (pr.author and pr.author.login or "?"):sub(1, 18)),
						string.format("%-22s", (#who > 0 and table.concat(who, ",") or "-"):sub(1, 22)),
						pr.title,
					}, " ")
				end

				vim.system({ "gh", "pr", "list", "--limit", "100", "--json", fields }, { text = true }, function(res)
					vim.schedule(function()
						if res.code ~= 0 then
							vim.notify(res.stderr or "gh pr list failed", vim.log.levels.ERROR)
							return
						end
						local lines = vim.tbl_map(format_pr, vim.json.decode(res.stdout))
						if #lines == 0 then
							vim.notify("No open pull requests", vim.log.levels.INFO)
							return
						end
						fzf.fzf_exec(lines, {
							prompt = "PRs> ",
							winopts = { title = " Pull Requests ", title_pos = "center" },
							fzf_opts = { ["--no-multi"] = "" },
							preview = "gh pr view {1}",
							actions = {
								["default"] = function(selected)
									local n = selected[1]:match("^(%d+)")
									if n then
										vim.cmd("Octo pr edit " .. n)
									end
								end,
							},
						})
					end)
				end)
			end,
			desc = "List GitHub PullRequests",
		},
		{
			"<leader>od",
			"<CMD>Octo discussion list<CR>",
			desc = "List GitHub Discussions",
		},
		{
			"<leader>on",
			"<CMD>Octo notification list<CR>",
			desc = "List GitHub Notifications",
		},
		{
			"<leader>os",
			function()
				require("octo.utils").create_base_search_command({ include_current_repo = true })
			end,
			desc = "Search GitHub",
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"ibhagwan/fzf-lua",
		-- OR "folke/snacks.nvim",
		"nvim-tree/nvim-web-devicons", -- optional if file_panel.icons is a function
	},
	config = function(_, opts)
		require("octo").setup(opts)

		-- Show sha/date/author in the commit picker list, not just the subject.
		-- Field 1 stays the full sha (octo hides it via --with-nth=2.. and keys on it).
		local em = require("octo.pickers.fzf-lua.entry_maker")
		local orig = em.gen_from_git_commits
		em.gen_from_git_commits = function(entry)
			local e = orig(entry)
			if not e then
				return nil
			end
			e.ordinal = table.concat({
				entry.sha,
				entry.sha:sub(1, 8),
				(entry.commit.author.date or ""):sub(1, 10),
				string.format("%-20s", entry.commit.author.name or "?"),
				(entry.commit.message:gsub("\n.*", "")),
			}, " ")
			return e
		end

		-- Octo concatenates `Accept: application/vnd.github.v3.diff` into an unquoted
		-- shell string (fzf-lua/previewers.lua:202), so `gh api` sees two positional
		-- args and the preview shows "accepts 1 arg(s), received 2" instead of the
		-- diff. Rebuild the preview with an argv list so no shell splitting happens.
		local previewers = require("octo.pickers.fzf-lua.previewers")
		local orig_commit = previewers.commit
		previewers.commit = function(formatted_commits, repo)
			local P = orig_commit(formatted_commits, repo)
			function P:populate_preview_buf(entry_str)
				local entry = formatted_commits[entry_str]
				if not entry then
					return
				end
				local buf = self:get_tmp_buffer()
				local lines = {
					string.format("Commit: %s", entry.value),
					string.format("Author: %s", entry.author),
					string.format("Date:   %s", entry.date),
					"",
				}
				vim.list_extend(lines, vim.split(entry.msg, "\n"))
				table.insert(lines, "")
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
				vim.bo[buf].filetype = "git"

				local res = vim
					.system({
						"gh",
						"api",
						"--paginate",
						string.format("/repos/%s/commits/%s", repo, entry.value),
						"-H",
						"Accept: application/vnd.github.v3.diff",
					}, { text = true })
					:wait()

				local body = res.code == 0 and res.stdout or ("Failed to fetch diff:\n" .. (res.stderr or "?"))
				vim.api.nvim_buf_set_lines(buf, #lines, -1, false, vim.split(body, "\n"))

				self:set_preview_buf(buf)
				self:update_border(entry.ordinal)
			end
			return P
		end
	end,
}
