return {
    -- 1. Main Markdown Renderer
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {
            -- Remove 'i' from rendering modes so the entire file falls back 
            -- to plain raw text the second you press 'i' or 'a'
            render_modes = { 'n', 'v', 'V', 'c', 't' }, 
            win_options = {
                -- render-markdown only understands `default` (used whenever the
                -- buffer is NOT in a rendered state, e.g. insert mode since 'i'
                -- is excluded from render_modes above) and `rendered`. There is
                -- no `raw` key, so the old `raw = false` here was silently ignored
                -- and insert mode fell back to `default = true`, which is why
                -- wrap stayed on. default/rendered are swapped to fix that.
                wrap = { default = false, rendered = true },
                breakindent = { default = true, rendered = true },
            },
            -- markdown-table-wrap.nvim owns pipe tables (reader/inline overlay);
            -- leaving both plugins rendering tables makes table-wrap's cached
            -- render state get out of sync with render-markdown's own table
            -- extmarks, so the table overlay doesn't come back after InsertLeave.
            pipe_table = {
                enabled = false,
            },
        },
        config = function(_, opts)
            require('render-markdown').setup(opts)
        end,
    },
    -- 2. Table Wrapping Handler
    {
        'ice345/markdown-table-wrap.nvim',
        ft = { 'markdown' },
        -- Default preview_mode = "reader": normal mode shows a fully rendered,
        -- non-modifiable Reader buffer; i/a/I/A/o/O drop you into the real
        -- Source buffer to edit. Other normal-mode commands (dd, p, x, ...) hit
        -- "E21: modifiable is off" there, since Reader intentionally blocks them.
        -- ("inline" avoids that lock but renders as a virtual-text overlay on
        -- real source lines, which the plugin's own docs say leaks stray `|`
        -- fragments and re-renders jumpily on wide/wrapped table rows — that's
        -- the gaps/jumpiness, not a bug in this config.)
        -- So: stay in Reader for viewing, hit <leader>me for a normal editable
        -- buffer, <leader>mr to flip back to the rendered Reader view.
        --
        -- render-markdown treats normal mode as a "rendered" mode too (that's
        -- what keeps headings/etc styled while just reading), so its win_options
        -- keep reasserting wrap = true on the Source buffer even in normal mode,
        -- fighting anything Source/table-wrap tries to set. buf_disable stops
        -- render-markdown from managing win_options for that buffer at all, so
        -- it falls back to (and stays at) our win_options.wrap default = false.
        -- buf_enable on the way back to Reader restores the normal mode-based
        -- wrap/decoration behavior.
        keys = {
            {
                '<leader>me',
                function()
                    vim.cmd('MarkdownTableEditSource')
                    vim.cmd('RenderMarkdown buf_disable')
                end,
                desc = 'Markdown table: edit source',
            },
            {
                '<leader>mr',
                function()
                    vim.cmd('RenderMarkdown buf_enable')
                    vim.cmd('MarkdownTableToggleReader')
                end,
                desc = 'Markdown table: toggle reader',
            },
        },
        opts = {},
    }
}

