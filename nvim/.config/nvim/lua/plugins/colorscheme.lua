return {
	{
		dir = vim.fn.expand("~/.config/nvim/lua/theme"),
		name = "custom-theme",
		lazy = false,
		priority = 1000,
		config = function()
			-- Function to read theme mode from file
			local function read_theme_mode()
				local theme_file = vim.fn.expand("~/.config/theme_mode")
				local file = io.open(theme_file, "r")
				if file then
					local mode = file:read("*line")
					file:close()
					return mode == "light" and "light" or "dark"
				end
				return "dark"
			end

			-- Function to apply theme
			local function apply_theme()
				local theme_mode = read_theme_mode()
				vim.o.background = theme_mode

				-- Reload the theme modules to get fresh colors
				package.loaded["theme.colors"] = nil
				package.loaded["theme.highlights"] = nil
				package.loaded["theme"] = nil

				-- Reapply the colorscheme
				vim.cmd.colorscheme("custom-theme")
			end

			-- Apply initial theme
			apply_theme()

			-- Watch theme_mode file for changes
			local theme_mode_file = vim.fn.expand("~/.config/theme_mode")
			local watch_handle = vim.uv.new_fs_event()
			if watch_handle then
				-- The callback receives err, fname, and events parameters
				watch_handle:start(theme_mode_file, {}, vim.schedule_wrap(function(err, fname, events)
					if not err then
						-- Debounce: only apply theme once even if multiple events fire
						vim.defer_fn(function()
							apply_theme()
						end, 50)
					end
				end))
			end

			-- Additional highlight overrides
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "custom-theme",
				callback = function()
					-- Transparent backgrounds
					vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
					vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
					vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
					vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
				end,
			})
		end,
	},
}
