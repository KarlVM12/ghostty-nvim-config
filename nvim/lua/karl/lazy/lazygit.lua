vim.g.lazygit_floating_window_winblend = 0 -- no transparency
vim.g.lazygit_floating_window_scaling_factor = 1.0
vim.g.lazygit_use_neovim_remote = true 

return {
  'kdheepak/lazygit.nvim',
  cmd = 'LazyGit',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
  },
}
