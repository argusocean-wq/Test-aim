-- LoadingSmokeTest.lua
-- Executable Raw-loader smoke test for a fixed, benign fixture only.
-- This intentionally does not load UE.txt or any third-party exploit script.

local SOURCE_URL = "https://raw.githubusercontent.com/argusocean-wq/Test-aim/main/SmokeTest.lua"
local EXPECTED_SOURCE = [=[-- SmokeTest.lua
-- Benign executable fixture for testing your own Raw loader.
print("[UE Loader Test] Smoke test executed successfully.")
return {
    status = "ok",
    message = "Benign loader smoke test completed",
}
]=]

local ok, source = pcall(function()
    return game:HttpGet(SOURCE_URL)
end)

if not ok or type(source) ~= "string" or #source == 0 then
    error("[UE Loader Test] Raw download failed; stopped.")
end

if source ~= EXPECTED_SOURCE then
    error("[UE Loader Test] Fixture content differs from the reviewed version; stopped.")
end

if type(loadstring) ~= "function" then
    error("[UE Loader Test] loadstring is unavailable in this environment; stopped.")
end

local chunk, compileError = loadstring(source)
if not chunk then
    error("[UE Loader Test] Compilation failed: " .. tostring(compileError))
end

local runOk, result = pcall(chunk)
if not runOk then
    error("[UE Loader Test] Execution failed: " .. tostring(result))
end

print("[UE Loader Test] PASS: download, exact-content check, compile, and execution.")
return result
