--------HPX SCRIPT AND HPX TEAM -----



fx_version 'bodacious'

version '0.0.0'

games { 'gta5' }

lua54 "yes"


ui_page 'html/index.html'
files {
  'html/index.html',
  'html/script.js',
  'html/style.css',
  'html/*otf',
  'html/*png',
  'html/*mp3',
  'html/*wav',
  'html/*ttf',
  'html/*TTF',
  'images/*.png',
  'images/*.jpg',
  'images/*.webp',
  'images/*.mp4',
  'images/*.svg',
}

client_scripts{
    'client/*.lua',
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server/*.lua',
}

shared_scripts {
	'shared/cores.lua',
  'shared/config.lua'
}

escrow_ignore {
	'shared/cores.lua',
  'shared/config.lua',
  'client/*.lua',
  'server/*.lua',
}


dependency '/assetpacks'


--------HPX SCRIPT AND HPX TEAM -----