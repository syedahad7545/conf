-- ========================================================================== --
--  1. CORE SETTINGS
-- ========================================================================== --
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2         -- Default is 4. Change to 2 here if you prefer.
vim.opt.shiftwidth = 2      -- Change to 2 here if you prefer.
vim.opt.softtabstop = 2     -- Change to 2 here if you prefer.
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.autoread = true -- Auto-reload files if they change on disk
-- ========================================================================== --
--  2. BOOTSTRAP LAZY.NVIM
-- ========================================================================== --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
    end
    vim.opt.rtp:prepend(lazypath)

    -- ========================================================================== --
    --  3. PLUGINS SETUP
    -- ========================================================================== --
    require("lazy").setup({

        -- >>> THEME: Kanagawa <<<
        {
            "rebelot/kanagawa.nvim",
            lazy = false,
            priority = 1000,
            config = function()
            require('kanagawa').setup({
                theme = "wave",
                background = { dark = "wave", light = "lotus" },
            })
            vim.cmd("colorscheme kanagawa")
            end
        },

        -- >>> TREESITTER (Syntax Highlighting) <<<
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            config = function()
            local status, configs = pcall(require, "nvim-treesitter.configs")
            if not status then return end

                configs.setup({
                    ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "python" },
                    sync_install = false,
                    auto_install = true,
                    highlight = { enable = true },
                    indent = { enable = true },
                })
                end
        },

        -- >>> LSP & AUTOCOMPLETION (The Brains) <<<
        {
            "neovim/nvim-lspconfig",
            dependencies = {
                "williamboman/mason.nvim",
                "williamboman/mason-lspconfig.nvim",
                "hrsh7th/nvim-cmp",
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "L3MON4D3/LuaSnip",
                "saadparwaiz1/cmp_luasnip",
            },
            config = function()
            -- 1. Setup Mason
            require("mason").setup()

            -- 2. Setup Autocompletion
            local cmp = require('cmp')
            local luasnip = require('luasnip')

            cmp.setup({
                snippet = {
                    expand = function(args)
                    luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                                                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                                                    ['<C-Space>'] = cmp.mapping.complete(),
                                                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                                                    ['<Tab>'] = cmp.mapping.select_next_item(),
                                                    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                })
            })

            -- 3. Connect LSP Servers
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            require("mason-lspconfig").setup({
                ensure_installed = { "clangd", "lua_ls", "pyright" },
                handlers = {
                    function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities
                    })
                    end,
                }
            })

            -- 4. Global Keymaps
            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                local opts = { buffer = event.buf }
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
                vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
                end,
            })
            end
        },

    })

    -- ========================================================================== --
    --  4. TRANSPARENCY TOGGLE COMMAND
    -- ========================================================================== --
    local is_transparent = false

    vim.api.nvim_create_user_command("ToggleTransparent", function()
    if is_transparent then
        -- RESTORE: Reloading the theme resets the background
        vim.cmd("colorscheme kanagawa")
        is_transparent = false
        print("Transparency: OFF")
        else
            -- TRANSPARENT: Force background to none
            vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
            -- Optional: Make the line number column transparent too
            vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
            is_transparent = true
            print("Transparency: ON")
            end
            end, {})

    -- Optional: Keybinding (Leader + bg)
    vim.keymap.set('n', '<leader>bg', ':ToggleTransparent<CR>', { noremap = true, silent = true })

    -- Sync clipboard between OS and Neovim.
    --  Remove this option if you want your OS clipboard to remain independent.
    --  See `:help 'clipboard'`
    vim.opt.clipboard = 'unnamedplus'
