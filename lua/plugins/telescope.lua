return {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
	local builtin = require('telescope.builtin')

	local function find_project_root(path)
	  local patterns = { ".git", "package.json", "Makefile", "*.sln", ".nvim.lua" }
	  local current = path
	  while true do
	    for _, pattern in ipairs(patterns) do
	      if pattern:find("*") then
	        if vim.fn.glob(current .. "/" .. pattern) ~= "" then return current end
	      else
	        if vim.fn.isdirectory(current .. "/" .. pattern) == 1 or
	           vim.fn.filereadable(current .. "/" .. pattern) == 1 then
	          return current
	        end
	      end
	    end
	    local parent = vim.fn.fnamemodify(current, ":h")
	    if parent == current then break end
	    current = parent
	  end
	  return path
	end

	local function get_project_name(root)
	  local nvim_lua = root .. "/.nvim.lua"
	  if vim.fn.filereadable(nvim_lua) == 1 then
	    local lines = vim.fn.readfile(nvim_lua)
	    for _, line in ipairs(lines) do
	      local name = line:match('vim%.g%.project_name%s*=%s*"([^"]+)"')
	      if name then return name end
	    end
	  end
	  return vim.fn.fnamemodify(root, ":t")
	end

	local function switch_project()
	  local history_file = vim.fn.stdpath("data") .. "/project_nvim/project_history"
	  local f = io.open(history_file, "r")
	  if not f then
	    vim.notify("No project history yet — open some projects first", vim.log.levels.WARN)
	    return
	  end
	  local seen = {}
	  local projects = {}
	  for line in f:lines() do
	    if line ~= "" then
	      local root = find_project_root(line)
	      if not seen[root] then
	        seen[root] = true
	        table.insert(projects, root)
	      end
	    end
	  end
	  f:close()

	  local final_projects = {}
	  for i, path in ipairs(projects) do
	    local is_child = false
	    for j, other_path in ipairs(projects) do
	      if i ~= j and vim.fn.strchars(other_path) < vim.fn.strchars(path) then
	        if string.sub(path, 1, vim.fn.strchars(other_path) + 1) == other_path .. "/" then
	          is_child = true
	          break
	        end
	      end
	    end
	    if not is_child then
	      table.insert(final_projects, path)
	    end
	  end
	  projects = final_projects

	  local pickers = require("telescope.pickers")
	  local finders = require("telescope.finders")
	  local conf = require("telescope.config").values
	  local actions = require("telescope.actions")
	  local action_state = require("telescope.actions.state")
	  local persistence = require("persistence")

	  pickers.new({}, {
	    prompt_title = "Switch Project",
	    finder = finders.new_table({
	      results = projects,
	      entry_maker = function(entry)
	        local name = get_project_name(entry)
	        return { value = entry, display = name .. " — " .. entry, ordinal = entry }
	      end,
	    }),
	    sorter = conf.generic_sorter({}),
	    attach_mappings = function(prompt_bufnr, _)
	      actions.select_default:replace(function()
	        actions.close(prompt_bufnr)
	        local selection = action_state.get_selected_entry()
	        if not selection then return end
	        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
	          if vim.api.nvim_buf_is_loaded(buf)
	            and vim.api.nvim_get_option_value("modified", { buf = buf }) then
	            vim.notify("Unsaved changes — save or discard before switching", vim.log.levels.WARN)
	            return
	          end
	        end
	        pcall(require("nvim-tree.api").tree.close)
	        persistence.save()
	        vim.cmd("silent! %bdelete!")
	        vim.cmd("cd " .. vim.fn.fnameescape(selection.value))
	        persistence.load()
	        local nvim_lua = selection.value .. "/.nvim.lua"
	        if vim.fn.filereadable(nvim_lua) == 1 then
	          vim.cmd("source " .. vim.fn.fnameescape(nvim_lua))
	        end
	        vim.schedule(function()
	          pcall(require("nvim-tree.api").tree.open, { path = selection.value })
	        end)
	      end)
	      return true
	    end,
	  }):find()
	end

	vim.keymap.set('n', '<leader>ff', function()
	    builtin.find_files({ cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1] or vim.fn.getcwd() })
	end, { desc = 'Telescope find files' })
	vim.keymap.set('n', '<leader>fg', function()
	    builtin.live_grep({ cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1] or vim.fn.getcwd() })
	end, { desc = 'Telescope live grep' })
	vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
	vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
	vim.keymap.set('n', '<leader>fp', switch_project, { desc = 'Switch project' })
    end
}
