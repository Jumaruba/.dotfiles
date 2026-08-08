-- Absolute path, so a mark taken in one project still resolves when the cwd is
-- somewhere else. Harpoon's default stores it relative to cwd.
local function buf_path(bufnr)
	local name = vim.api.nvim_buf_get_name(bufnr or 0)
	if name == "" then
		return ""
	end
	return vim.fs.normalize(name)
end

local function add_file()
	if buf_path(0) == "" then
		vim.notify("Harpoon: buffer has no file", vim.log.levels.WARN)
		return
	end

	require("harpoon"):list():add()
end

local function quick_menu()
	local harpoon = require("harpoon")
	harpoon.ui:toggle_quick_menu(harpoon:list())
end

local function harpoon_fzf()
	local global = require("harpoon"):list()
	local entries = {}

	for index = 1, global:length() do
		local item = global:get(index)

		if item and item.value and item.value ~= "" then
			-- Shorten for display only; selection is by index.
			local display = vim.fn.fnamemodify(item.value, ":~")
			table.insert(entries, string.format("%d: %s", index, display))
		end
	end

	require("fzf-lua").fzf_exec(entries, {
		prompt = "Harpoon> ",

		actions = {
			["default"] = function(selected)
				if not selected or not selected[1] then
					return
				end

				local index = tonumber(selected[1]:match("^(%d+):"))

				if index then
					global:select(index)
				end
			end,

			["ctrl-d"] = function(selected)
				if not selected or not selected[1] then
					return
				end

				local index = tonumber(selected[1]:match("^(%d+):"))
				local item = index and global:get(index)

				if item then
					global:remove(item)
				end
			end,
		},

		winopts = {
			width = 0.6,
			height = 0.5,
		},
	})
end

return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"ibhagwan/fzf-lua",
	},

	-- Every mapping lives here rather than in config(), so each one also acts as
	-- a lazy-load trigger. Defined in config() they would not exist until some
	-- other harpoon key had loaded the plugin first.
	keys = {
		-- Drop LazyVim's bare <leader>h: it makes the <leader>h* prefix wait for
		-- timeoutlen on every press. <leader>hh replaces it.
		{ "<leader>h", false },
		{ "<leader>hh", quick_menu, desc = "Harpoon: Quick menu" },
		{ "<leader>hl", harpoon_fzf, desc = "Harpoon: Global files" },
		{ "<leader>ha", add_file, desc = "Harpoon: Add current file" },
		{
			"<leader>hr",
			function()
				require("harpoon"):list():remove()
			end,
			desc = "Harpoon: Remove current file",
		},
		-- Point LazyVim's add at the guarded version too.
		{ "<leader>H", add_file, desc = "Harpoon: Add current file" },
	},

	config = function()
		local harpoon = require("harpoon")
		local extensions = require("harpoon.extensions")

		harpoon:setup({
			settings = {
				-- A constant key means one data file shared by every project,
				-- instead of harpoon's default of one file per cwd.
				key = function()
					return "global"
				end,
				save_on_toggle = true,
				sync_on_ui_close = true,
			},

			default = {
				create_list_item = function(_, name)
					name = name or buf_path(0)

					local pos = { 1, 0 }
					if vim.fn.bufnr(name, false) == vim.api.nvim_get_current_buf() then
						pos = vim.api.nvim_win_get_cursor(0)
					end

					return {
						value = name,
						context = { row = pos[1], col = pos[2] },
					}
				end,

				BufLeave = function(arg, list)
					local path = buf_path(arg.buf)
					if path == "" then
						return
					end

					local item = list:get_by_value(path)
					if not item then
						return
					end

					local pos = vim.api.nvim_win_get_cursor(0)
					item.context.row = pos[1]
					item.context.col = pos[2]

					extensions.extensions:emit(extensions.event_names.POSITION_UPDATED, item)
				end,
			},
		})
	end,
}
