function setupRootElement()
  local root = {}
  root.id = 'rootElement'
  root.visible = true
  root.color = 'red'
  root['background color'] = 'yellow'
  root.text = 'Main Window'
  root.children = {
    { id = 'child1', zOrder = 1, visible = true, parent = root },
    { id = 'child2', zOrder = 2, visible = true, parent = root },
    { id = 'child3', zOrder = 3, visible = false, clickVolume = 0.02, parent = root },
  }
  root.savedIndexes = { 4, 1, 3, 2, 5, total = 5 }
  root.layoutPositions = { 'top', 'left', 'bottom', 'right' }
  root.innerLengths = { x = 1, l = { x = 2, l = { x = 3, l = { x = 4, l = { x = 5, l = { x = 6 } } } } } }

  return root
end

function table.tostring(t, maxDepth, indent)
  local visited = {}
  local formatTable

  local function formatKey(key)
    if type(key) == "string" then
      return string.format("[%q]", key)
    end

    return string.format("[%s]", tostring(key))
  end

  local function formatValue(value, depth)
    if type(value) == "table" then
      return formatTable(value, depth + 1)
    elseif type(value) == "string" then
      return string.format("%q", value)
    end

    return tostring(value)
  end

  formatTable = function(current, depth)
    if visited[current] then
      return string.format("%q", tostring(current))
    end

    if depth >= maxDepth then
      return "{}"
    end

    visited[current] = true

    local lines = {}
    local childIndent = string.rep(indent, depth + 1)
    local sequenceLength = #current

    for i = 1, sequenceLength do
      lines[#lines + 1] = string.format(
        "%s%s,\n",
        childIndent,
        formatValue(current[i], depth)
      )
    end

    for key, value in pairs(current) do
      local isSequenceEntry = type(key) == "number"
        and key % 1 == 0
        and key >= 1
        and key <= sequenceLength

      if not isSequenceEntry then
        lines[#lines + 1] = string.format(
          "%s%s = %s,\n",
          childIndent,
          formatKey(key),
          formatValue(value, depth)
        )
      end
    end

    return string.format(
      "{\n%s%s}",
      table.concat(lines),
      string.rep(indent, depth)
    )
  end

  return formatTable(t, 0)
end

local function validateTableString(tableString)
  local chunk, err = load(string.format("return %s", tableString))
  -- exercise demands to use loadstring, but is deprecated in Lua 5.2 and later, so using load instead
  if not chunk then
    error(string.format("Invalid table: %s", err))
  end
end

function main()
  local root = setupRootElement()
  local result = table.tostring(root, 3, "  ")

  validateTableString(result)
  print(result)
end

main()
