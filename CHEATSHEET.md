# Neovim Cheat Sheet

**Leader key:** `<Space>`

---

## Finding & Opening Files

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files in project (Telescope) |
| `<leader>fg` | Search text across project (Telescope live grep) |
| `<leader>fb` | Browse open buffers (Telescope) |
| `<leader>fh` | Search help tags (Telescope) |
| `<leader>e` | Toggle file explorer sidebar (press again to close) |
| `<leader>o` | Focus file explorer sidebar (press `<C-l>` to return to editor, press `a` to add file) |
| `r` | Rename file in file tree (when cursor is on the file) |
| `<leader>a` | Bookmark current file (Harpoon) |
| `<C-e>` | Open bookmark list (Harpoon quick menu) — press `<C-e>` again or `<Esc>` to close |
| `<M-1>` | Jump to bookmark 1 |
| `<C-t>` | Jump to bookmark 2 |
| `<C-n>` | Jump to bookmark 3 |
| `<C-s>` | Jump to bookmark 4 |
| `<C-S-P>` | Previous bookmark |
| `<C-S-N>` | Next bookmark |

---

## Code Navigation

| Key | Action |
|-----|--------|
| `grd` | Go to definition |
| `<C-o>` | Jump back (after going to definition, etc.) |
| `<C-i>` | Jump forward |
| `<leader>grr` | Find references (Telescope picker — press `q` or `<Esc>` to close) |
| `<leader>grs` | Search workspace symbols (Telescope picker — press `q` or `<Esc>` to close) |
| `<leader>dk` | Previous diagnostic |
| `<leader>dj` | Next diagnostic |

---

## Understanding Code

*LSP keymaps are active only when a language server is attached.*

| Key | Mode | Action |
|-----|------|--------|
| `K` | normal | Hover documentation |
| `<C-h>` | insert | Signature help (parameter hints) |
| `<leader>vd` | normal | Show diagnostics for current line |

---

## Editing & Refactoring

| Key | Mode | Action |
|-----|------|--------|
| `ggVG` | normal | Select all text |
| `<leader>vrn` | normal | Rename symbol |
| `<leader>vca` | normal | Code actions |
| `<C-Space>` | insert | Trigger completion |
| `<CR>` | insert | Confirm completion |
| `<C-e>` | insert | Abort completion |
| `<Tab>` | insert/select | Next completion item or jump snippet forward |
| `<S-Tab>` | insert/select | Previous completion item or jump snippet back |
| `<C-b>` | insert | Scroll completion docs up |
| `<C-f>` | insert | Scroll completion docs down |
| `<leader>dc` | normal | compare with clipboard (`<leader>dx` to leave) |


---

## Git

### Hunk navigation (gitsigns — visible while editing)

| Key | Action |
|-----|--------|
| `<leader>hj` | Next changed hunk |
| `<leader>hk` | Previous changed hunk |
| `<leader>hs` | Stage hunk under cursor |
| `<leader>hu` | Undo last hunk stage |
| `<leader>hr` | Reset hunk to HEAD |
| `<leader>hp` | Preview hunk inline (show diff) |
| `<leader>hb` | Toggle line blame (show who changed this line) |

### Git commands (fugitive)

| Key | Action |
|-----|--------|
| `<leader>gs` | Open git status window |
| `<leader>gc` | Git commit |
| `<leader>gp` | Git push |
| `<leader>gl` | Git pull |
| `<leader>gb` | Git blame (full file) |
| `<leader>gd` | Diff current file against HEAD (split) |

**Inside the fugitive status window:**
- `s` — stage file
- `u` — unstage file
- `=` — toggle inline diff for file under cursor
- `dv` — vertical diff split (file vs HEAD)
- `cc` — commit (opens editor)
- `q` — close status window and return to editor

---

## Windows & Splits

| Key | Action |
|-----|--------|
| `<leader>sv` | Split vertically |
| `<leader>sh` | Split horizontally |
| `<leader>se` | Equalize split sizes |
| `<leader>sx` | Close current split |
| `<C-h>` | Move to left window |
| `<C-l>` | Move to right window |
| `<C-j>` | Move to bottom window |
| `<C-k>` | Move to top window |
| `<leader>q` | Close quickfix panel |
| `<leader>e` | Toggle file/folder tree |

---

## Buffers / Tabs

| Key | Action |
|-----|--------|
| `<S-h>` | Previous buffer |
| `<S-l>` | Next buffer |
| `<leader>bx` | Close current buffer |
| `<leader>bo` | Close all other buffers |
| `<leader>bp` | Pin / unpin buffer |
| `<leader>bP` | Close all unpinned buffers |
| `<leader>bl` | Close all buffers to the left |
| `<leader>br` | Close all buffers to the right |

> `<S-h>` / `<S-l>` override vim's built-in `H` / `L` (jump to top/bottom of visible screen).

---

## Session

Sessions are saved per working directory on exit. nvim-tree is excluded from saves so it doesn't break on restore.

| Key | Action |
|-----|--------|
| `<leader>qs` | Restore session for current directory |
| `<leader>ql` | Restore last session |
| `<leader>qd` | Disable session saving for this run |

> Auto-restore on startup may not always fire — `<leader>qs` is the reliable path.

---

## Diff

| Key | Action |
|-----|--------|
| `<leader>dc` | Diff current buffer against clipboard (opens vertical split) |
| `do` | Accept changes from clipboard into current file (while in diff mode) |
| `<leader>dx` | Exit diff mode & close clipboard split |

---

## Discovery

| Key | Action |
|-----|--------|
| `<leader>?` | Show all keymaps for current buffer (which-key) |

---

## Config Issues

| Location | Issue | Status |
|----------|-------|--------|
| `lua/config/keybinds.lua:2` | `<leader>cd` opens netrw, which is disabled | Remove or repurpose |
| `lua/plugins/bufferline.lua` | `<S-h>` / `<S-l>` override vim's `H` / `L` screen-navigation keys | Intentional trade-off |

### Harpoon overrides these Vim built-ins

| Key | Was | Now |
|-----|-----|-----|
| `<C-t>` | Jump back in tag stack | Harpoon bookmark 2 |
| `<C-n>` | Next completion / cmdline history | Harpoon bookmark 3 |

---

## Notes

- **LSP servers:** Lua (`lua_ls`), TypeScript/JavaScript (`ts_ls`), SQL (`sqlls`)
- **Snippets:** LuaSnip with VS Code–style friendly-snippets collection
- **Project config:** Set a `.nvim.lua` file in project root, with `vim.g.project_name = "my project name"` to have title of console set with the defined project name
