vim.g.fff = {
    lazy_sync = true,
    prompt = "",
    title = "Files",
    layout = {
        prompt_position = "top",
        preview_position = "bottom",
        flex = { wrap = "bottom" },
    },
}

local plugin
local function fff()
    if not plugin then
        vim.pack.add({ "https://github.com/dmtrKovalenko/fff" })
        plugin = require("fff")
    end
    return plugin
end

vim.keymap.set("n", "<leader>ff", function() fff().find_files() end)
vim.keymap.set("n", "<leader>fg", function() fff().live_grep() end)
vim.keymap.set("n", "<leader>fr", function() fff().resume() end)

vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == "fff" and (kind == "install" or kind == "update") then
            if not ev.data.active then vim.cmd.packadd("fff") end
            require("fff.download").download_or_build_binary()
        end
    end,
})
