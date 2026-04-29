{ config, ... }:

{
  programs.nvf = {
    enable = true;

    settings.vim = {
      theme = {
        enable = true;
        name = "base16";
        style = "dark";
      };

      # Stylix injects colors via base16 — no need to hardcode
      clipboard.registers = "unnamedplus";
      lineNumberMode = "number";

      lsp.enable = true;

      languages = {
        enableFormat = true;
        enableTreesitter = true;

        nix.enable = true;
        bash.enable = true;
        lua.enable = true;
        markdown.enable = true;
        toml.enable = true;
        yaml.enable = true;
        json.enable = true;
      };

      visuals = {
        indent-blankline.enable = true;
        nvim-web-devicons.enable = true;
      };

      statusline.lualine.enable = true;
      telescope.enable = true;
      autocomplete.nvim-cmp.enable = true;
      filetree.neo-tree.enable = true;
      git.enable = true;
      git.neogit.enable = true;

      luaConfigRC.devicons-setup = ''
        vim.g.have_nerd_font = true
      '';

      luaConfigRC.neo-tree-navigation = ''
        -- Neo-tree tiene su propio buffer con keymaps propios; remapear jklñ dentro de él
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "neo-tree",
          callback = function(ev)
            local buf = ev.buf
            local opts = { buffer = buf, noremap = false, silent = true }
            -- j → h (cierra nodo / sube al padre)
            vim.keymap.set("n", "j", "h", opts)
            -- l → j (cursor abajo)
            vim.keymap.set("n", "l", "j", opts)
            -- ñ → l (abre nodo / entra al directorio)
            vim.keymap.set("n", "ñ", "l", opts)
          end,
        })
      '';

      keymaps = [
        # -- Navegación: jklñ en lugar de hjkl --
        { mode = "n"; key = "j"; action = "h"; desc = "Mover izquierda"; noremap = true; }
        { mode = "n"; key = "l"; action = "j"; desc = "Mover abajo";     noremap = true; }
        { mode = "n"; key = "ñ"; action = "l"; desc = "Mover derecha";   noremap = true; }
        { mode = "v"; key = "j"; action = "h"; desc = "Mover izquierda"; noremap = true; }
        { mode = "v"; key = "l"; action = "j"; desc = "Mover abajo";     noremap = true; }
        { mode = "v"; key = "ñ"; action = "l"; desc = "Mover derecha";   noremap = true; }
        { mode = "o"; key = "j"; action = "h"; desc = "Mover izquierda"; noremap = true; }
        { mode = "o"; key = "l"; action = "j"; desc = "Mover abajo";     noremap = true; }
        { mode = "o"; key = "ñ"; action = "l"; desc = "Mover derecha";   noremap = true; }

        # -- Explorador de archivos --
        { mode = "n"; key = "<leader>e"; action = "<cmd>Neotree toggle<CR>"; desc = "Toggle explorador"; }
        { mode = "n"; key = "<leader>o"; action = "<cmd>Neotree focus<CR>"; desc = "Foco al explorador"; }

        # -- Telescope --
        { mode = "n"; key = "<leader>ff"; action = "<cmd>Telescope find_files<CR>"; desc = "Buscar archivos"; }
        { mode = "n"; key = "<leader>fg"; action = "<cmd>Telescope live_grep<CR>"; desc = "Buscar texto (grep)"; }
        { mode = "n"; key = "<leader>fb"; action = "<cmd>Telescope buffers<CR>"; desc = "Buscar buffers"; }
        { mode = "n"; key = "<leader>fh"; action = "<cmd>Telescope help_tags<CR>"; desc = "Buscar ayuda"; }
        { mode = "n"; key = "<leader>fr"; action = "<cmd>Telescope oldfiles<CR>"; desc = "Archivos recientes"; }
        { mode = "n"; key = "<leader>fd"; action = "<cmd>Telescope diagnostics<CR>"; desc = "Buscar diagnosticos"; }

        # -- Buffers --
        { mode = "n"; key = "<leader>x"; action = "<cmd>bdelete<CR>"; desc = "Cerrar buffer"; }
        { mode = "n"; key = "<Tab>"; action = "<cmd>bnext<CR>"; desc = "Buffer siguiente"; }
        { mode = "n"; key = "<S-Tab>"; action = "<cmd>bprevious<CR>"; desc = "Buffer anterior"; }

        # -- Ventanas / splits --
        { mode = "n"; key = "<leader>sv"; action = "<cmd>vsplit<CR>"; desc = "Split vertical"; }
        { mode = "n"; key = "<leader>sh"; action = "<cmd>split<CR>"; desc = "Split horizontal"; }
        { mode = "n"; key = "<leader>sx"; action = "<cmd>close<CR>"; desc = "Cerrar split"; }
        { mode = "n"; key = "<C-j>"; action = "<C-w>h"; desc = "Ir a split izquierdo"; noremap = true; }
        { mode = "n"; key = "<C-k>"; action = "<C-w>k"; desc = "Ir a split arriba";    noremap = true; }
        { mode = "n"; key = "<C-l>"; action = "<C-w>j"; desc = "Ir a split abajo";     noremap = true; }
        { mode = "n"; key = "<C-ñ>"; action = "<C-w>l"; desc = "Ir a split derecho";   noremap = true; }

        # -- LSP --
        { mode = "n"; key = "gd"; action = "<cmd>lua vim.lsp.buf.definition()<CR>"; desc = "Ir a definicion"; }
        { mode = "n"; key = "gr"; action = "<cmd>lua vim.lsp.buf.references()<CR>"; desc = "Ver referencias"; }
        { mode = "n"; key = "K"; action = "<cmd>lua vim.lsp.buf.hover()<CR>"; desc = "Hover info"; }
        { mode = "n"; key = "<leader>ca"; action = "<cmd>lua vim.lsp.buf.code_action()<CR>"; desc = "Code actions"; }
        { mode = "n"; key = "<leader>rn"; action = "<cmd>lua vim.lsp.buf.rename()<CR>"; desc = "Renombrar simbolo"; }
        { mode = "n"; key = "<leader>dn"; action = "<cmd>lua vim.diagnostic.goto_next()<CR>"; desc = "Siguiente diagnostico"; }
        { mode = "n"; key = "<leader>dp"; action = "<cmd>lua vim.diagnostic.goto_prev()<CR>"; desc = "Anterior diagnostico"; }

        # -- Git --
        { mode = "n"; key = "<leader>gg"; action = "<cmd>Neogit<CR>"; desc = "Abrir Neogit"; }
        { mode = "n"; key = "<leader>gb"; action = "<cmd>Telescope git_branches<CR>"; desc = "Git branches"; }
        { mode = "n"; key = "<leader>gc"; action = "<cmd>Telescope git_commits<CR>"; desc = "Git commits"; }
        { mode = "n"; key = "<leader>gs"; action = "<cmd>Telescope git_status<CR>"; desc = "Git status"; }

        # -- k explícito (arriba) para consistencia en todos los modos --
        { mode = "n"; key = "k"; action = "k"; desc = "Mover arriba"; noremap = true; }
        { mode = "v"; key = "k"; action = "k"; desc = "Mover arriba"; noremap = true; }
        { mode = "o"; key = "k"; action = "k"; desc = "Mover arriba"; noremap = true; }

        # -- Utilidades --
        { mode = "n"; key = "<leader>w"; action = "<cmd>w<CR>"; desc = "Guardar"; }
        { mode = "n"; key = "<leader>q"; action = "<cmd>q<CR>"; desc = "Salir"; }
        { mode = "n"; key = "<leader>h"; action = "<cmd>nohlsearch<CR>"; desc = "Quitar highlight busqueda"; }
        { mode = "n"; key = "<A-j>"; action = "<cmd>m .+1<CR>=="; desc = "Mover linea abajo"; }
        { mode = "n"; key = "<A-k>"; action = "<cmd>m .-2<CR>=="; desc = "Mover linea arriba"; }
        { mode = "v"; key = "<A-j>"; action = ":m '>+1<CR>gv=gv"; desc = "Mover seleccion abajo"; }
        { mode = "v"; key = "<A-k>"; action = ":m '<-2<CR>gv=gv"; desc = "Mover seleccion arriba"; }
        { mode = "v"; key = "<"; action = "<gv"; desc = "Indentar izquierda y mantener seleccion"; }
        { mode = "v"; key = ">"; action = ">gv"; desc = "Indentar derecha y mantener seleccion"; }
      ];
    };
  };
}
