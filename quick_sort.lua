--[[
  quick Sort using the last element as pivot
  On an already sorted array, this choice produces highly unbalanced partitions. This leads to O(n^2) time complexity in the worst case
]]

local function quickSortRecursive(array, startIndex, endIndex)
  if startIndex >= endIndex then
    return
  end

  local pivot = array[endIndex]
  local i = startIndex - 1

  for j = startIndex, endIndex - 1 do
    if array[j] <= pivot then
      i = i + 1
      array[i], array[j] = array[j], array[i]
    end
  end

  local pivotIndex = i + 1
  array[pivotIndex], array[endIndex] = array[endIndex], array[pivotIndex]

  quickSortRecursive(array, startIndex, pivotIndex - 1)
  quickSortRecursive(array, pivotIndex + 1, endIndex)
end

local function heapSort(array, startIndex, endIndex)
  local count = endIndex - startIndex + 1

  local function siftDown(rootIndex, heapSize)
    while true do
      local childIndex = rootIndex * 2 + 1

      if childIndex >= heapSize then
        return
      end

      if childIndex + 1 < heapSize
        and array[startIndex + childIndex] < array[startIndex + childIndex + 1] then
        childIndex = childIndex + 1
      end

      if array[startIndex + rootIndex] >= array[startIndex + childIndex] then
        return
      end

      array[startIndex + rootIndex], array[startIndex + childIndex] =
        array[startIndex + childIndex], array[startIndex + rootIndex]
      rootIndex = childIndex
    end
  end

  for index = math.floor(count / 2) - 1, 0, -1 do
    siftDown(index, count)
  end

  for heapSize = count - 1, 1, -1 do
    array[startIndex], array[startIndex + heapSize] =
      array[startIndex + heapSize], array[startIndex]
    siftDown(0, heapSize)
  end
end

local function randomizedQuickSort(array, startIndex, endIndex, depthLimit)
  if startIndex >= endIndex then
    return
  end

  if depthLimit == 0 then
    heapSort(array, startIndex, endIndex)
    return
  end

  local randomPivotIndex = math.random(startIndex, endIndex)
  array[randomPivotIndex], array[endIndex] = array[endIndex], array[randomPivotIndex]

  local pivot = array[endIndex]
  local i = startIndex - 1

  for j = startIndex, endIndex - 1 do
    if array[j] <= pivot then
      i = i + 1
      array[i], array[j] = array[j], array[i]
    end
  end

  local pivotIndex = i + 1
  array[pivotIndex], array[endIndex] = array[endIndex], array[pivotIndex]

  randomizedQuickSort(array, startIndex, pivotIndex - 1, depthLimit - 1)
  randomizedQuickSort(array, pivotIndex + 1, endIndex, depthLimit - 1)
end

--[[
  introsort
  uses randomized pivots to improve partition balance.
  When the recursion depth limit is reached, it switches to Heap Sort,
  preventing quadratic worst-case behavior and guaranteeing O(n log n)
  worst-case time complexity
]]

local function introspectiveQuickSort(array, startIndex, endIndex)
  local size = endIndex - startIndex + 1
  local depthLimit = 0

  while size > 1 do
    depthLimit = depthLimit + 2
    size = math.floor(size / 2)
  end

  randomizedQuickSort(array, startIndex, endIndex, depthLimit)
end

local function createArray(size, generator)
  local array = {}

  for i = 1, size do
    array[i] = generator(i)
  end

  return array
end

local function copyArray(array)
  local copy = {}

  for i, value in ipairs(array) do
    copy[i] = value
  end

  return copy
end

local function isSorted(array)
  for i = 2, #array do
    if array[i - 1] > array[i] then
      return false
    end
  end

  return true
end

local function measureTime(sortFunction, sourceArray, repetitions)
  local totalMilliseconds = 0

  for _ = 1, repetitions do
    local array = copyArray(sourceArray)
    local start = os.clock()
    sortFunction(array, 1, #array)
    totalMilliseconds = totalMilliseconds + (os.clock() - start) * 1000

    if not isSorted(array) then
      error("The sorting function produced an incorrect result.")
    end
  end

  return totalMilliseconds / repetitions, true
end

math.randomseed(os.time())

local nLogNExample = { 1, 3, 2, 6, 5, 7, 4 }
quickSortRecursive(nLogNExample, 1, #nLogNExample)
print("Example with balanced partitions:", table.concat(nLogNExample, ", "))
--[[
  with reasonably balanced partitions, Quick Sort has O(n log n) average-case time complexity
]]

local size = 5000

--[[
  an already sorted array causes the original Quick Sort to produce
  highly unbalanced partitions because it always selects the last element.
  This demonstrates its O(n^2) worst case time complexity.
]]
local sortedInput = createArray(size, function(i)
  return i
end)

local repetitions = 3
local originalTime, originalSorted = measureTime(quickSortRecursive, sortedInput, repetitions)
local alternativeTime, alternativeSorted = measureTime(introspectiveQuickSort, sortedInput, repetitions)


print("Worst-case example: sorted input with " .. size .. " elements.")

print(string.format("Original Quick Sort: %.2f ms", originalTime))

print(string.format("Introspective Quick Sort: %.2f ms", alternativeTime))

print("Both versions sorted the input correctly:", originalSorted and alternativeSorted)

local references = {
  "Wikipedia (quicksort): https://en.wikipedia.org/wiki/Quicksort",
  "Wikipedia (introsort): https://en.wikipedia.org/wiki/Introsort",
  "Wikipedia (heapsort): https://en.wikipedia.org/wiki/Heapsort",
  "Video reference(quick sort): https://www.youtube.com/watch?v=PJnHzFypGaI",
  "Video reference(heap sort): https://www.youtube.com/watch?v=2DmK_H7IdTo",
  "Lua Manual(osclock): https://www.lua.org/manual/5.4/manual.html#pdf-os.clock"
}

print("\nReferences:")
for _, reference in ipairs(references) do
  print("- " .. reference)
end
