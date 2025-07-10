-- Put this at the top of 'init.lua'
local path_package = vim.fn.stdpath("data") .. "/site"
local mini_path = path_package .. "/pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		-- Uncomment next line to use 'stable' branch
		-- '--branch', 'stable',
		"https://github.com/echasnovski/mini.nvim",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

local deps = require("mini.deps")

-- Neovim native settings
vim.o.number = true
vim.o.relativenumber = true

vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = "yes"

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.o.mouse = ""

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.scrolloff = 5

vim.o.wrap = false

-- VSCode Compatible

deps.add("tpope/vim-repeat")
deps.add("tpope/vim-surround")
deps.add("justinmk/vim-sneak")
vim.g["sneak#s_next"] = 1
vim.keymap.set("", "f", "<Plug>Sneak_f")
vim.keymap.set("", "F", "<Plug>Sneak_F")
vim.keymap.set("", "t", "<Plug>Sneak_t")
vim.keymap.set("", "T", "<Plug>Sneak_T")

-- start mini.nvim
local basics = require("mini.basics")
basics.setup({
	options = { basic = false },
	mappings = {
		windows = true,
	},
})
local ai = require("mini.ai")
ai.setup()
local align = require("mini.align")
align.setup()
local comment = require("mini.comment")
comment.setup()
local keymap = require("mini.keymap")
keymap.setup()
local map_multistep = require("mini.keymap").map_multistep
map_multistep("i", "<Tab>", { "pmenu_next" })
map_multistep("i", "<S-Tab>", { "pmenu_prev" })
map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
map_multistep("i", "<BS>", { "minipairs_bs" })

local move = require("mini.move")
move.setup()
local operators = require("mini.operators")
operators.setup()
local pairs = require("mini.pairs")
pairs.setup()
local splitjoin = require("mini.splitjoin")
splitjoin.setup()
-- local surround = require("mini.surround")
-- surround.setup()
local diff = require("mini.diff")
diff.setup()
local extra = require("mini.extra")
extra.setup()
local files = require("mini.files")
files.setup()
vim.keymap.set("n", "<leader>e", files.open, { desc = "file [e]xplorer" })
-- local jump = require("mini.jump")
-- jump.setup()
local misc = require("mini.misc")
misc.setup()
local pick = require("mini.pick")
pick.setup()
vim.ui.select = pick.ui_select
vim.keymap.set("n", "<leader>ff", pick.builtin.files, { desc = "[f]iles" })
vim.keymap.set("n", "<leader>fb", pick.builtin.buffers, { desc = "[b]uffers" })
vim.keymap.set("n", "<leader>fh", pick.builtin.help, { desc = "[h]elp" })
local trailspace = require("mini.trailspace")
trailspace.setup()
vim.keymap.set("n", "<leader>tt", trailspace.trim, { desc = "[trim]" })
-- end mini.nvim

-- Otherwise
if not vim.g.vscode then
	-- deps.add("sainnhe/sonokai")
	-- vim.g.sonokai_enable_italic = true
	-- vim.g.sonokai_style = "shusia"
	-- vim.cmd("colorscheme sonokai")
	deps.add("catppuccin/nvim")
	vim.cmd.colorscheme("catppuccin")

	-- start mini.nvim
	local completion = require("mini.completion")
	completion.setup()
	local snippets = require("mini.snippets")
	snippets.setup()

	local clue = require("mini.clue")
	clue.setup({
		triggers = {
			-- Leader triggers
			{ mode = "n", keys = "<Leader>" },
			{ mode = "x", keys = "<Leader>" },

			-- Built-in completion
			{ mode = "i", keys = "<C-x>" },

			-- `g` key
			{ mode = "n", keys = "g" },
			{ mode = "x", keys = "g" },

			-- Marks
			{ mode = "n", keys = "'" },
			{ mode = "n", keys = "`" },
			{ mode = "x", keys = "'" },
			{ mode = "x", keys = "`" },

			-- Registers
			{ mode = "n", keys = '"' },
			{ mode = "x", keys = '"' },
			{ mode = "i", keys = "<C-r>" },
			{ mode = "c", keys = "<C-r>" },

			-- Window commands
			{ mode = "n", keys = "<C-w>" },

			-- `z` key
			{ mode = "n", keys = "z" },
			{ mode = "x", keys = "z" },
		},

		clues = {
			-- Enhance this by adding descriptions for <Leader> mapping groups
			clue.gen_clues.builtin_completion(),
			clue.gen_clues.g(),
			clue.gen_clues.marks(),
			clue.gen_clues.registers(),
			clue.gen_clues.windows(),
			clue.gen_clues.z(),
			{ mode = "n", keys = "<leader>f", desc = "+[f]ind" },
			{ mode = "n", keys = "<leader>l", desc = "+[l]sp" },
			{ mode = "n", keys = "<leader>d", desc = "+[d]ebug" },
		},
	})

	local animate = require("mini.animate")
	local scroll_timing = animate.gen_timing.linear({ duration = 1.5, unit = "step", easing = "in-out" })
	local timing = animate.gen_timing.linear({ duration = 100, unit = "total" })
	animate.setup({
		cursor = { timing = timing },
		scroll = { timing = scroll_timing },
		resize = { timing = timing },
		open = { timing = timing },
		close = { timing = timing },
	})
	local cursorword = require("mini.cursorword")
	cursorword.setup()
	local hipatterns = require("mini.hipatterns")
	hipatterns.setup({
		highlighters = {
			-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
			fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
			hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
			todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
			note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

			-- Highlight hex color strings (`#rrggbb`) using that color
			hex_color = hipatterns.gen_highlighter.hex_color(),
		},
	})
	local icons = require("mini.icons")
	icons.setup()
	local indentscope = require("mini.indentscope")
	indentscope.setup()
	local notify = require("mini.notify")
	notify.setup()
	vim.notify = require("mini.notify").make_notify()
	vim.api.nvim_create_autocmd("User", {
		pattern = "MiniStarterOpened",
		callback = function(ev)
			vim.b[ev.buf].miniindentscope_disable = true
		end,
	})
	local starter = require("mini.starter")
	local content_type_width = function(content, section_type)
		local coords = starter.content_coords(content, section_type)
		local width = math.max(unpack(vim.tbl_map(function(c)
			local line = content[c.line][c.unit].string
			return vim.fn.strdisplaywidth(line)
		end, coords)))
		return width
	end
	deps.add({ source = "MaximilianLloyd/ascii.nvim", depends = { "MunifTanjim/nui.nvim" } })
	starter.setup({
		header = table.concat(require("ascii").art.text.neovim.dos_rebel, "\n"),
		evaluate_single = true,
		footer = os.date(),
		items = {
			starter.sections.pick(),
			starter.sections.builtin_actions(),
		},
		content_hooks = {
			starter.gen_hook.adding_bullet("› "),
			function(content)
				-- Coords
				local header_width = content_type_width(content, "header")
				local section_width = content_type_width(content, "section")
				local item_width = content_type_width(content, "item")
				local footer_width = content_type_width(content, "footer")
				local max_width = math.max(header_width, section_width, item_width, footer_width)

				for _, line in ipairs(content) do
					if not (#line == 0 or (#line == 1 and line[1].string == "")) then
						local line_str = ""
						local line_types = {}
						for _, unit in ipairs(line) do
							line_str = line_str .. unit.string
							table.insert(line_types, unit.type)
						end
						local line_width = 0
						for _, type in ipairs(line_types) do
							if type == "item" or type == "section" then
								line_width = math.max(item_width, section_width)
							elseif type == "header" then
								line_width = header_width
							elseif type == "footer" then
								line_width = footer_width
							end
						end
						local left_pad = string.rep(" ", (max_width - line_width) * 0.5)

						table.insert(line, 1, { string = left_pad, type = "empty" })
					end
				end
				return content
			end,
			starter.gen_hook.aligning("center", "center"),
		},
	})
	local statusline = require("mini.statusline")
	statusline.setup()
	local tabline = require("mini.tabline")
	tabline.setup()
	-- end mini.nvim

	-- start snacks.nvim
	deps.add("folke/snacks.nvim")
	local snacks = require("snacks")
	snacks.setup({
		statuscolumn = {},
	})
	-- end snacks.nvim

	deps.add("folke/lazydev.nvim")
	require("lazydev").setup({})

	-- conform
	deps.add("stevearc/conform.nvim")
	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_format" },
			go = { "gofumpt", "gofmt" },
			javascript = { "prettier" },
			javascriptreact = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			yaml = { "yamlfix" },
		},
		format_on_save = {
			lsp_format = "fallback",
			timeout_ms = 2000,
		},
	})

	-- Language specific plugins
	deps.add("janet-lang/janet.vim")
	vim.g["conjure#filetype#janet"] = "conjure.client.janet.stdio"

	-- lsp configurations
	vim.keymap.set("n", "<leader>lr", function()
		vim.lsp.buf.rename()
	end, { desc = "[r]ename" })
	vim.keymap.set("n", "<leader>la", function()
		vim.lsp.buf.code_action()
	end, { desc = "[a]ction" })
	vim.keymap.set("n", "gd", function()
		vim.lsp.buf.definition()
	end, { desc = "goto definition (lsp)" })
	deps.add("neovim/nvim-lspconfig")
	vim.lsp.enable("lua_ls")
	vim.lsp.enable("pyright")
	vim.lsp.enable("basedpyright")
	vim.lsp.enable("ruff")
	vim.lsp.enable("gopls")
	vim.lsp.enable("ts_ls")

	-- treesitter
	deps.add({
		source = "nvim-treesitter/nvim-treesitter",
		checkout = "main",
		hooks = {
			post_checkout = function()
				vim.cmd("TSUpdate")
			end,
		},
	})
	--- enable treesitter based folding
	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	vim.opt.foldlevel = 99
	--- autocmd to start treesitter syntax highlighting
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "python", "go", "javascript", "javascriptreact", "typescript", "typescriptreact" },
		callback = function()
			vim.treesitter.start()
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end,
	})

	deps.add("nvim-treesitter/nvim-treesitter-context") -- shows what function/data structure the cursor is inside

	-- NeoGit
	deps.add({ source = "NeogitOrg/neogit", depends = { "nvim-lua/plenary.nvim" } })
	vim.keymap.set("n", "<leader>g", "<cmd>Neogit<cr>", { desc = "neo[g]it" })

	-- Conjure (repl integration)
	deps.add("Olical/conjure")
	vim.g["conjure#mapping#doc_word"] = "gk"

	-- markview
	deps.add("OXY2DEV/markview.nvim")
	require("markview").setup({
		preview = {
			icon_provider = "internal",
			hybrid_modes = { "i" },
		},
	})

	-- debugging
	deps.add("mfussenegger/nvim-dap")
	local dap = require("dap")
	vim.keymap.set("n", "<F5>", function()
		dap.continue()
	end, { desc = "Start debugging" })
	vim.keymap.set("n", "<S-F5>", function()
		dap.terminate()
	end, { desc = "Stop debugging" })
	vim.keymap.set("n", "<F9>", function()
		dap.toggle_breakpoint()
	end, { desc = "Toggle breakpoint" })
	vim.keymap.set("n", "<F10>", function()
		dap.step_over()
	end, { desc = "Step over" })
	vim.keymap.set("n", "<F11>", function()
		dap.step_over()
	end, { desc = "Step into" })
	vim.keymap.set("n", "<S-F11>", function()
		dap.step_out()
	end, { desc = "Step out" })
	deps.add({ source = "rcarriga/nvim-dap-ui", depends = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } })
	local dapui = require("dapui")
	dapui.setup()
	vim.keymap.set("n", "<leader>dt", function()
		dapui.toggle()
	end, { desc = "[t]oggle ui" })
	deps.add("mfussenegger/nvim-dap-python")
	require("dap-python").setup("python")
end
