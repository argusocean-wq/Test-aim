-- UE Raw loader template
-- Note: UE.txt must contain the reviewed source before this loader can run.
-- This loader fails closed if the source is missing or is still a placeholder.

local SOURCE_URL = "https://raw.githubusercontent.com/argusocean-wq/Test-aim/main/UE.txt"

local ok, source = pcall(function()
    return game:HttpGet(SOURCE_URL)
end)

if not ok or type(source) ~= "string" or #source == 0 then
    error("[UE] Failed to download source; execution stopped.")
end

if source:find("SOURCE_NOT_PUBLISHED", 1, true) then
    error("[UE] Source has not been published; execution stopped.")
end

local compile, compileError = loadstring(source)
if not compile then
    error("[UE] Source compilation failed: " .. tostring(compileError))
end

return compile()
