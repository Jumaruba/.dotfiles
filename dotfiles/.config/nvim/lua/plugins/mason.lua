return {
	"mason-org/mason.nvim",
	opts_extend = { "ensure_installed" },
	opts = {
		ensure_installed = {
			"stylua",
			"shfmt",
			"basedpyright",
			"rust-analyzer",
			"marksman",
			"prettier",
			"tofu-ls",
			"json-lsp",
			"ruff",
		},
	},
}
