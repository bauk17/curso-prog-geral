local craftRecipes = {
  {
    name = 'chair',
    ingredients = {
      { name = 'wood', count = 4 },
      { name = 'paint', count = 1 },
      { name = 'nail', count = 4 },
    },
  },
  {
    name = 'table',
    ingredients = {
      { name = 'wood', count = 8 },
      { name = 'paint', count = 1 },
      { name = 'nail', count = 4 },
    },
  },
  {
    name = 'halloween costume',
    ingredients = {
      { name = 'pumpkin', count = 1 },
      { name = 'cloth', count = 8 },
      { name = 'cloth', count = 8 },
    },
  },
  {
    name = 'stone axe',
    ingredients = {
      { name = 'wood', count = 2 },
      { name = 'stone', count = 2 },
      { name = 'cloth', count = 8 },
    },
  },
}

local craftsByIngredient = {}
local requiredIngredientsByRecipe = {}

function setupCraftsByIngredient()
  craftsByIngredient = {}
  requiredIngredientsByRecipe = {}

  for _, recipe in ipairs(craftRecipes) do
    local addedIngredients = {}
    local requiredIngredients = {}

    for _, ingredient in ipairs(recipe.ingredients) do
      local name = ingredient.name
      requiredIngredients[name] = (requiredIngredients[name] or 0) + ingredient.count

      if not addedIngredients[name] then
        craftsByIngredient[name] = craftsByIngredient[name] or {}
        table.insert(craftsByIngredient[name], recipe)
        addedIngredients[name] = true
      end
    end

    requiredIngredientsByRecipe[recipe] = requiredIngredients
  end
end

function getRecipes()
  return craftRecipes
end

function getRecipesByIngredientName(name)
  return craftsByIngredient[name] or {}
end

function getAvailableRecipes(ingredients)
  local availableIngredients = {}
  local foundRecipes = {}

  for _, ingredient in ipairs(ingredients) do
    local name = ingredient.name
    availableIngredients[name] = (availableIngredients[name] or 0) + ingredient.count
    for _, recipe in ipairs(craftsByIngredient[name] or {}) do
      foundRecipes[recipe] = true
    end
  end

  local availableRecipes = {}
  for recipe in pairs(foundRecipes) do
    local canCraft = true

    for name, requiredCount in pairs(requiredIngredientsByRecipe[recipe]) do
      if (availableIngredients[name] or 0) < requiredCount then
        canCraft = false
        break
      end
    end

    if canCraft then
      table.insert(availableRecipes, recipe)
    end
  end

  return availableRecipes
end

function main()
  setupCraftsByIngredient()

  local recipes = getAvailableRecipes({
    { name = 'wood', count = 5 },
    { name = 'nail', count = 4 },
    { name = 'paint', count = 30 },
  })

  for _, recipe in ipairs(recipes) do
    print(recipe.name)
  end
end

main()
