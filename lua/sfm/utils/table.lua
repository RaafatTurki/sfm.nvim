function table.extend(dest, src)
  for _, v in pairs(src) do
    table.insert(dest, v)
  end

  return dest
end

function table.remove_key(items, key)
  items[key] = nil
end

function table.contains_key(items, key)
  return items[key] and true or false
end

function table.is_matrix(tbl)
  if type(tbl) ~= "table" then
    return false
  end

  for _, v in pairs(tbl) do
    if type(v) ~= "table" then
      return false
    end
  end

  return true
end
