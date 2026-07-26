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
			-- fetches author/createdAt/reviewRequests/labels/checks. Go via `gh` to get them.
			"<leader>op",
			"<CMD>Octo pr list<CR>",
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
}
