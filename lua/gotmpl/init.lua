local M = {}

M.setup = function()
	vim.treesitter.query.add_directive("inject-go-tmpl!", function(_, _, bufnr, _, metadata)
		local fname = vim.fs.basename(vim.api.nvim_buf_get_name(bufnr))
		local base_extention = fname:match("%.([a-z0-9_]+)%.tmpl$")
		local ft = nil
		if not base_extention then
			base_extention = fname:match("^(.-)%.tmpl$")
			---@diagnostic disable-next-line: cast-local-type
			ft = vim.filetype.match({ filename = base_extention })
		else
			---@diagnostic disable-next-line: cast-local-type
			ft = vim.filetype.match({ filename = "file." .. base_extention })
		end
		if not ft then
			metadata["injection.language"] = "gotmpl"
			return
		end
		metadata["injection.language"] = ft
	end, {})
	-- Make sure vim recognizes .tmpl files as gotmpl ft
	vim.filetype.add({
		extension = {
			tmpl = "gotmpl",
		},
	})

	vim.treesitter.query.set(
		"gotmpl",
		"injections",
		[[
			((text) @injection.content
				(#inject-go-tmpl!)
				(#set! injection.combined))
		]]
	)
end

return M
