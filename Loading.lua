-- UE Raw source inspection loader (safe / non-executing)
-- Fetches source text for inspection only.
-- It deliberately does NOT call loadstring or execute downloaded code.

local SOURCE_URL = "https://raw.githubusercontent.com/argusocean-wq/Test-aim/main/UE.txt"
local MAX_SOURCE_BYTES = 16 * 1024 * 1024

local function fetchSource()
    assert(game ~= nil, "[UE] Roblox game context is unavailable.")

    local ok, source = pcall(function()
        return game:HttpGet(SOURCE_URL)
    end)

    if not ok then
        error("[UE] Download failed; source was not processed.")
    end

    if type(source) ~= "string" or #source == 0 then
        error("[UE] Download returned empty or invalid content.")
    end

    if #source > MAX_SOURCE_BYTES then
        error("[UE] Source exceeds the inspection size limit.")
    end

    if source:find("SOURCE_NOT_PUBLISHED", 1, true) then
        error("[UE] Source is still a placeholder; inspection stopped.")
    end

    return source
end

local source = fetchSource()

print(string.format(
    "[UE] Downloaded source for inspection only (%d bytes). No code was executed.",
    #source
))

-- Return text for manual review; never compile or execute remote source.
return {
    status = "downloaded_for_inspection",
    url = SOURCE_URL,
    bytes = #source,
    source = source,
}
