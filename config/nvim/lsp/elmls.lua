return {
    cmd = { "elm-language-server" },
    init_options = {
        elmTestPath = "elm-test-rs",
    },
    root_markers = {
        "elm.json",
        "elm-package.json",
    },
    filetypes = {
        "elm",
    },
}
