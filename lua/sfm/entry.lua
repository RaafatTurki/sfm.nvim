local path = require "sfm.utils.path"
local fs = require "sfm.utils.fs"

---@class Entry
---@field name string
---@field path string
---@field is_dir boolean
---@field is_symlink boolean
---@field parent Entry
---@field depth integer
---@field is_root boolean
---@field entries Entry[]
local Entry = {}

function Entry.new(fpath, parent, is_root)
  local self = setmetatable({}, { __index = Entry })

  fpath = path.clean(fpath)
  local name = path.basename(fpath)

  self.name = name
  self.path = fpath
  self.is_dir = path.isdir(fpath)
  self.is_symlink = path.islink(fpath)
  self.entries = {}
  self.parent = parent
  self.is_root = is_root
  self.is_open = false
  self.is_selected = false

  if parent == nil then
    self.depth = 0
  else
    self.depth = self.parent.depth + 1
  end

  return self
end

function Entry:scandir()
  if not self.is_dir then
    return
  end

  local entries = {}

  local paths = fs.scandir(self.path)
  for _, fpath in ipairs(paths) do
    table.insert(entries, Entry.new(fpath, self, false))
  end

  -- TODO: allow users to custom entry's order
  table.sort(entries, function(a, b)
    if a.is_dir and b.is_dir then
      return string.lower(a.name) < string.lower(b.name)
    elseif a.is_dir then
      return true
    elseif b.is_dir then
      return false
    end

    return string.lower(a.name) < string.lower(b.name)
  end)

  self.entries = entries
end

return Entry
