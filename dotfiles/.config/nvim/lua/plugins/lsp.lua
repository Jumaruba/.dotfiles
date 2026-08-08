-- Which servers attach for python is decided by `vim.g.lazyvim_python_lsp` and
-- `vim.g.lazyvim_python_ruff` in config/options.lua -- the lang.python extra
-- reads those and enables the pair (and mutes ruff's hover in favour of
-- basedpyright's). This file only carries their settings.
return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				coffeesense = {
					mason = false, -- installed globally via npm
				},
				basedpyright = {
					settings = {
						basedpyright = {
							-- ruff sorts imports, see ruff_organize_imports below
							disableOrganizeImports = true,
							analysis = {
								-- basedpyright defaults to "recommended", which errors on every
								-- implicit Any. "standard" matches pyright's strictness.
								typeCheckingMode = "standard",
								diagnosticSeverityOverrides = {
									-- ruff reports these as F401/F841
									reportUnusedImport = "none",
									reportUnusedVariable = "none",
								},
							},
						},
					},
				},
				ruff = {
					init_options = {
						settings = {
							logLevel = "error",
							-- A project's own pyproject.toml/ruff.toml wins over these by
							-- default; set configurationPreference = "editorFirst" to flip that.
							lint = {
								select = { "E", "F", "I", "UP", "B" },
								ignore = {
									"E731", -- Do not assign a lambda expression, use a def
									"F403", -- From {name} import * used; unable to detect undefined names
									"F405", -- {name} may be undefined, or defined from star imports
								},
							},
						},
					},
				},
			},
		},
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				python = { "ruff_organize_imports", "ruff_format" },
			},
		},
	},
}
