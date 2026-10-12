-- LoadingOfflineTest.lua
-- Offline-only regression tests for the UE loader's safety gates.
-- This file does NOT fetch, compile, or execute UE.txt.
-- Compatible with standard Lua 5.1+; run with: lua LoadingOfflineTest.lua

local function shouldReject(source)
    if type(source) ~= "string" or #source == 0 then
        return true, "empty-or-invalid"
    end

    if source:find("SOURCE_NOT_PUBLISHED", 1, true) then
        return true, "placeholder"
    end

    return false, "source-present"
end

local tests = {
    {
        name = "nil source is rejected",
        source = nil,
        reject = true,
        reason = "empty-or-invalid",
    },
    {
        name = "empty source is rejected",
        source = "",
        reject = true,
        reason = "empty-or-invalid",
    },
    {
        name = "placeholder source is rejected",
        source = "-- SOURCE_NOT_PUBLISHED",
        reject = true,
        reason = "placeholder",
    },
    {
        name = "placeholder marker in source is rejected",
        source = "print('test') -- SOURCE_NOT_PUBLISHED",
        reject = true,
        reason = "placeholder",
    },
    {
        name = "ordinary test text passes only the gate",
        source = "-- benign offline test fixture",
        reject = false,
        reason = "source-present",
    },
}

local failed = 0

for _, test in ipairs(tests) do
    local rejected, reason = shouldReject(test.source)
    local passed = rejected == test.reject and reason == test.reason

    if passed then
        print("[PASS] " .. test.name)
    else
        failed = failed + 1
        print("[FAIL] " .. test.name
            .. " (rejected=" .. tostring(rejected)
            .. ", reason=" .. tostring(reason) .. ")")
    end
end

print(string.format("\n%d/%d tests passed", #tests - failed, #tests))

if failed > 0 then
    os.exit(1)
end
