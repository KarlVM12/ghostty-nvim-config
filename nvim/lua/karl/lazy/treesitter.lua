return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = {
	"c", "lua", "html", "vim", "cpp", "c_sharp", "php", "css", "go", "rust", "zig", "bash", "cmake","dockerfile","elvish","http","java","javascript","json","kotlin","make","odin","python","regex","sql","terraform"
      },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
