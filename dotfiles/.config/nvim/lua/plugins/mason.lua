return {
	"mason-org/mason.nvim",
	opts_extend = { "ensure_installed" },
	opts = {
		ensure_installed = {
			"stylua",
			"shfmt",
			"pyright",
			"rust-analyzer",
			"marksman",
			"tofu-ls",
			"json-lsp",
		},
	},
}
