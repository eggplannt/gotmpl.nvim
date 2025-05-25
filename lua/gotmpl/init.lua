local M = {}

M.setup = function()
	vim.treesitter.query.add_directive("inject-go-tmpl!", function(_, _, bufnr, _, metadata)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		local ft = vim.filetype.match({ filename = string.sub(fname, 1, string.len(fname) - 5) })
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

	-- Moved query inline
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
