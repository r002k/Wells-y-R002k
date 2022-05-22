fx_version 'adamant'

game 'gta5'

version '1.0.0'

ui_page "html/ui.html"

files {
    "html/ui.html",
    "html/ui.css",
    "html/loading-bar.js",
    "html/ui.js",
    "html/**/*.png",
    'html/principal.ttf',
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/server.lua'
}