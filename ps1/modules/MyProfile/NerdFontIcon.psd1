@{
  File          = 'nf-oct-file'
  Directory     = 'nf-oct-file_directory'
  Junction      = 'nf-fa-external_link'
  SymbolicLink  = @{
    File      = 'nf-oct-file_symlink_file'
    Directory = 'nf-oct-file_symlink_directory'
  }
  DirectoryName = @{
    '.android'         = 'nf-dev-android'
    '.aws'             = 'nf-dev-aws'
    '.azure'           = 'nf-cod-azure'
    '.bin'             = 'nf-oct-file_binary'
    '.cache'           = 'nf-md-cached'
    '.config'          = 'nf-custom-folder_config'
    '.docker'          = 'nf-dev-docker'
    '.git'             = 'nf-custom-folder_git'
    '.github'          = 'nf-dev-github'
    '.idea'            = 'nf-dev-jetbrains'
    '.kube'            = 'nf-md-ship_wheel'
    '.vscode-insiders' = 'nf-dev-vscode'
    '.vscode'          = 'nf-dev-vscode'
    android            = 'nf-dev-android'
    app                = 'nf-md-application_edit'
    applications       = 'nf-md-apps'
    apps               = 'nf-md-apps'
    artifact           = 'nf-cod-package'
    artifacts          = 'nf-cod-package'
    asset              = 'nf-fa-file_code'
    assets             = 'nf-fa-file_code'
    benchmark          = 'nf-md-timer'
    benchmarks         = 'nf-md-timer'
    bin                = 'nf-oct-file_binary'
    build              = 'nf-cod-project'
    client             = 'nf-md-laptop'
    config             = 'nf-custom-folder_config'
    contact            = 'nf-md-contacts'
    contacts           = 'nf-md-contacts'
    data               = 'nf-dev-database'
    database           = 'nf-dev-database'
    demo               = 'nf-fa-democrat'
    desktop            = 'nf-md-desktop_classic'
    dev                = 'nf-md-dev_to'
    development        = 'nf-md-dev_to'
    dist               = 'nf-md-package_variant'
    doc                = 'nf-md-file_document_edit_outline'
    docs               = 'nf-md-file_document_edit_outline'
    document           = 'nf-md-file_document_multiple'
    documents          = 'nf-md-file_document_multiple'
    download           = 'nf-md-folder_download'
    downloads          = 'nf-md-folder_download'
    favorite           = 'nf-md-folder_star'
    favorites          = 'nf-md-folder_star'
    font               = 'nf-fa-font'
    fonts              = 'nf-fa-font'
    github             = 'nf-cod-github'
    image              = 'nf-md-folder_image'
    images             = 'nf-md-folder_image'
    ios                = 'nf-md-apple_ios'
    lib                = 'nf-cod-library'
    library            = 'nf-cod-library'
    libs               = 'nf-cod-library'
    linux              = 'nf-dev-linux'
    macos              = 'nf-dev-apple'
    media              = 'nf-dev-html5_multimedia'
    module             = 'nf-oct-apps'
    modules            = 'nf-oct-apps'
    movie              = 'nf-md-movie'
    movies             = 'nf-md-movie'
    music              = 'nf-md-music_box_multiple'
    node_modules       = 'nf-md-nodejs'
    onedrive           = 'nf-dev-onedrive'
    out                = 'nf-cod-output'
    photo              = 'nf-md-folder_image'
    resource           = 'nf-md-file_cabinet'
    resources          = 'nf-md-file_cabinet'
    photos             = 'nf-md-folder_image'
    picture            = 'nf-md-folder_image'
    pictures           = 'nf-md-folder_image'
    public             = 'nf-md-search_web'
    script             = 'nf-md-script'
    scripts            = 'nf-md-script'
    server             = 'nf-cod-server'
    song               = 'nf-md-music_box_multiple'
    songs              = 'nf-md-music_box_multiple'
    src                = 'nf-cod-code'
    target             = 'nf-cod-target'
    test               = 'nf-md-test_tube'
    tests              = 'nf-md-test_tube'
    tool               = 'nf-cod-tools'
    tools              = 'nf-cod-tools'
    umbraco            = 'nf-md-umbraco'
    user               = 'nf-fa-users'
    users              = 'nf-fa-users'
    util               = 'nf-cod-tools'
    utils              = 'nf-cod-tools'
    video              = 'nf-md-movie'
    videos             = 'nf-md-movie'
    web                = 'nf-md-web'
    windows            = 'nf-custom-windows'
  }
  Extension     = @{
    # Archive files
    '.7z'                   = 'nf-oct-file_zip'
    '.br'                   = 'nf-oct-file_zip'
    '.brotli'               = 'nf-oct-file_zip'
    '.bz'                   = 'nf-oct-file_zip'
    '.bzip2'                = 'nf-oct-file_zip'
    '.gz'                   = 'nf-oct-file_zip'
    '.gzip'                 = 'nf-oct-file_zip'
    '.rar'                  = 'nf-oct-file_zip'
    '.tar.bz2'              = 'nf-oct-file_zip'
    '.tar.gz'               = 'nf-oct-file_zip'
    '.tar.xz'               = 'nf-oct-file_zip'
    '.tar.zst'              = 'nf-oct-file_zip'
    '.tar'                  = 'nf-oct-file_zip'
    '.tbz2'                 = 'nf-oct-file_zip'
    '.tgz'                  = 'nf-oct-file_zip'
    '.txz'                  = 'nf-oct-file_zip'
    '.xz'                   = 'nf-oct-file_zip'
    '.zip'                  = 'nf-oct-file_zip'
    '.zst'                  = 'nf-oct-file_zip'

    # Executable things
    '.exe'                  = 'nf-md-application'
    '.dll'                  = 'nf-cod-file_binary'
    '.lib'                  = 'nf-cod-file_binary'
    '.dylib'                = 'nf-cod-file_binary'

    # App Packages
    '.dmg'                  = 'nf-fa-app_store'
    '.pkg'                  = 'nf-fa-app_store'
    '.msi'                  = 'nf-dev-windows'
    '.msix'                 = 'nf-dev-windows'
    '.msixbundle'           = 'nf-dev-windows'
    '.appx'                 = 'nf-dev-windows'
    '.AppxBundle'           = 'nf-dev-windows'
    '.deb'                  = 'nf-dev-debian'
    '.rpm'                  = 'nf-dev-fedora'
    '.gradle'               = 'nf-md-elephant'
    '.apex'                 = 'nf-dev-android'
    '.apk'                  = 'nf-dev-android'
    '.xapk'                 = 'nf-dev-android'
    '.obb'                  = 'nf-dev-android'
    '.aab'                  = 'nf-dev-android'

    # Source Code
    # applescript
    '.applescript'          = 'nf-dev-apple'
    # aspnetcorerazor
    # batch
    '.bat'                  = 'nf-cod-terminal_cmd'
    '.cmd'                  = 'nf-cod-terminal_cmd'
    # bibtex
    # bicep
    '.bicep'                = 'nf-seti-bicep'
    # blazor
    '.blazor'               = 'nf-dev-blazor'
    # c
    '.h'                    = 'nf-md-language_c'
    '.c'                    = 'nf-md-language_c'
    # clojure
    '.clj'                  = 'nf-dev-clojure'
    '.cljc'                 = 'nf-dev-clojure'
    '.cljs'                 = 'nf-dev-clojure'
    # codeql
    '.codeql'               = 'nf-md-code_parentheses'
    # coffeescript
    # cpp
    '.c++'                  = 'nf-md-language_cpp'
    '.cc'                   = 'nf-md-language_cpp'
    '.cpp'                  = 'nf-md-language_cpp'
    '.cxx'                  = 'nf-md-language_cpp'
    # csharp
    '.cs'                   = 'nf-md-language_csharp'
    '.csx'                  = 'nf-md-language_csharp'
    '.dib'                  = 'nf-cod-notebook'
    # cshtml
    # css
    '.css'                  = 'nf-dev-css3'
    # csv
    '.csv'                  = 'nf-fa-file_csv'
    '.tsv'                  = 'nf-seti-csv'
    # cuda-cpp
    # dart
    '.dart'                 = 'nf-dev-dart'
    # diff
    '.diff'                 = 'nf-oct-diff'
    # dockercompose
    # dockerfile
    '.dockerignore'         = 'nf-dev-docker'
    '.dockerfile'           = 'nf-dev-docker'
    # dtd
    '.dtd'                  = 'nf-md-xml'
    # fish
    '.fish'                 = 'nf-fa-fish'
    # fsharp
    '.fs'                   = 'nf-dev-fsharp'
    '.fsx'                  = 'nf-dev-fsharp'
    '.fsi'                  = 'nf-dev-fsharp'
    '.fsproj'               = 'nf-dev-fsharp'
    # git-commit
    # git-rebase
    # go
    '.go'                   = 'nf-dev-go'
    # graphql
    '.gql'                  = 'nf-dev-graphql'
    '.graphql'              = 'nf-dev-graphql'
    # groovy
    '.groovy'               = 'nf-dev-groovy'
    # handlebars
    '.hbs'                  = 'nf-dev-handlebars'
    # hlsl
    # html
    '.asp'                  = 'nf-seti-html'
    '.htm'                  = 'nf-seti-html'
    '.html'                 = 'nf-seti-html'
    '.xhtml'                = 'nf-seti-html'
    # ignore
    # ini
    # instructions
    # jade
    '.pug'                  = 'nf-seti-jade'
    '.jade'                 = 'nf-seti-jade'
    # java
    '.java'                 = 'nf-fae-java'
    '.jar'                  = 'nf-fae-java'
    # javascript
    '.js'                   = 'nf-dev-javascript'
    '.cjs'                  = 'nf-dev-javascript'
    '.mjs'                  = 'nf-dev-javascript'
    # javascriptreact
    '.jsx'                  = 'nf-fa-react'
    # jinja2
    # json
    '.json'                 = 'nf-seti-json'
    '.tsbuildinfo'          = 'nf-seti-json'
    '.jscsrc'               = 'nf-seti-json'
    '.jshintrc'             = 'nf-seti-json'
    'tsconfig.json'         = 'nf-seti-json'
    'tslint.json'           = 'nf-seti-json'
    'composer.lock'         = 'nf-seti-json'
    '.jsbeautifyrc'         = 'nf-seti-json'
    '.esformatter'          = 'nf-seti-json'
    'cdp.pid'               = 'nf-seti-json'
    # jsonc
    '.jsonc'                = 'nf-seti-json'
    # jsonl
    '.jsonl'                = 'nf-seti-json'
    # julia
    '.jl'                   = 'nf-dev-julia'
    # juliamarkdown
    # kotlin
    '.kt'                   = 'nf-dev-kotlin'
    '.kts'                  = 'nf-dev-kotlin'
    # latex
    '.latex'                = 'nf-dev-latex'
    # less
    '.less'                 = 'nf-dev-less'
    # log
    '.log'                  = 'nf-oct-log'
    # lua
    '.lua'                  = 'nf-seti-lua'
    # makefile
    '.mk'                   = 'nf-seti-makefile'
    # markdown
    '.markdown'             = 'nf-dev-markdown'
    '.md'                   = 'nf-dev-markdown'
    # objective-c
    '.objc'                 = 'nf-dev-objectivec'
    # objective-cpp
    '.objcpp'               = 'nf-dev-objectivec'
    # perl
    '.pl'                   = 'nf-dev-perl'
    # php
    '.php'                  = 'nf-dev-php'
    # plaintext
    '.txt'                  = 'nf-seti-text'
    # powershell
    '.clixml'               = 'nf-dev-powershell'
    '.ps1'                  = 'nf-dev-powershell'
    '.psm1'                 = 'nf-dev-powershell'
    '.psd1'                 = 'nf-dev-powershell'
    '.ps1xml'               = 'nf-dev-powershell'
    '.psc1'                 = 'nf-dev-powershell'
    '.pssc'                 = 'nf-dev-powershell'
    # prompt
    # properties
    '.ini'                  = 'nf-cod-gear'
    '.dlc'                  = 'nf-cod-gear'
    '.config'               = 'nf-cod-gear'
    '.conf'                 = 'nf-cod-gear'
    '.properties'           = 'nf-cod-gear'
    '.prop'                 = 'nf-cod-gear'
    '.settings'             = 'nf-cod-gear'
    '.option'               = 'nf-cod-gear'
    '.reg'                  = 'nf-cod-gear'
    '.props'                = 'nf-cod-gear'
    '.prefs'                = 'nf-cod-gear'
    '.sln.dotsettings'      = 'nf-cod-gear'
    '.sln.dotsettings.user' = 'nf-cod-gear'
    '.cfg'                  = 'nf-cod-gear'
    # puppet
    '.pp'                   = 'nf-custom-puppet'
    '.epp'                  = 'nf-custom-puppet'
    # purescript
    '.purs'                 = 'nf-dev-purescript'
    # python
    '.gyp'                  = 'nf-dev-python'
    '.ipynb'                = 'nf-dev-jupyter'
    '.py'                   = 'nf-dev-python'
    '.pyc'                  = 'nf-dev-python'
    '.pyd'                  = 'nf-dev-python'
    '.pyi'                  = 'nf-dev-python'
    '.pyw'                  = 'nf-dev-python'
    # r
    '.R'                    = 'nf-dev-r'
    '.Rmd'                  = 'nf-dev-r'
    '.Rproj'                = 'nf-dev-r'
    # raku
    # razor
    '.razor'                = 'nf-md-razor_double_edge'
    # restructuredtext
    '.rst'                  = 'nf-md-format_textbox'
    # ruby
    '.rb'                   = 'nf-oct-ruby'
    '.erb'                  = 'nf-oct-ruby'
    '.gemfile'              = 'nf-oct-ruby'
    'rakefile'              = 'nf-oct-ruby'
    # rust
    '.rs'                   = 'nf-dev-rust'
    # sass
    '.sass'                 = 'nf-dev-sass'
    # scala
    '.scala'                = 'nf-dev-scala'
    '.sc'                   = 'nf-dev-scala'
    '.sbt'                  = 'nf-dev-scala'
    # scheme
    # scss
    '.scss'                 = 'nf-dev-sass'
    # shaderlab
    # shellscript
    '.bash'                 = 'nf-dev-bash'
    '.sh'                   = 'nf-seti-shell'
    # sql
    '.mssql'                = 'nf-dev-sqldeveloper'
    '.pgsql'                = 'nf-dev-sqldeveloper'
    '.postgres'             = 'nf-dev-sqldeveloper'
    '.psql'                 = 'nf-dev-sqldeveloper'
    '.sql'                  = 'nf-dev-sqldeveloper'
    '.sqla'                 = 'nf-dev-sqlalchemy'
    # sqlite
    '.sqlite'               = 'nf-dev-sqlite'
    '.sqlite3'              = 'nf-dev-sqlite'
    # svelte
    '.svelte'               = 'nf-seti-svelte'
    # swift
    '.swift'                = 'nf-dev-swift'
    # terraform
    '.tf'                   = 'nf-dev-code_badge'
    '.tfvars'               = 'nf-dev-code_badge'
    '.tf.json'              = 'nf-dev-code_badge'
    '.tfvars.json'          = 'nf-dev-code_badge'
    '.auto.tfvars'          = 'nf-dev-code_badge'
    '.auto.tfvars.json'     = 'nf-dev-code_badge'
    # tex
    '.tex'                  = 'nf-dev-tex'
    # toml
    '.toml'                 = 'nf-custom-toml'
    # typescript
    '.ts'                   = 'nf-seti-typescript'
    '.cts'                  = 'nf-seti-typescript'
    '.mts'                  = 'nf-seti-typescript'
    # typescriptreact
    '.tsx'                  = 'nf-dev-react'
    # vb
    '.vb'                   = 'nf-dev-visualbasic'
    '.vbs'                  = 'nf-dev-visualbasic'
    # vim
    '.vim'                  = 'nf-dev-vim'
    '.nvim'                 = 'nf-custom-neovim'
    # vue
    '.vue'                  = 'nf-md-vuejs'
    # xaml
    '.xaml'                 = 'nf-md-language_xaml'
    # xml
    '.manifest'             = 'nf-md-xml'
    '.iml'                  = 'nf-md-xml'
    '.plist'                = 'nf-md-xml'
    '.project'              = 'nf-md-xml'
    '.resx'                 = 'nf-md-xml'
    '.tmLanguage'           = 'nf-md-xml'
    '.xml'                  = 'nf-md-xml'
    '.xquery'               = 'nf-md-xml'
    '.xsd'                  = 'nf-md-xml'
    '.htaccess'             = 'nf-md-xml'
    # xsl
    '.xslt'                 = 'nf-md-xml'
    '.xsl'                  = 'nf-md-xml'
    # yaml
    '.yaml'                 = 'nf-dev-yaml'
    '.yml'                  = 'nf-dev-yaml'
    # zig
    '.zig'                  = 'nf-dev-zig'
    # zsh
    # elixir
    '.eex'                  = 'nf-custom-elixir'
    '.ex'                   = 'nf-custom-elixir'
    '.exs'                  = 'nf-custom-elixir'
    # elm
    '.elm'                  = 'nf-custom-elm'
    # erlang
    '.erl'                  = 'nf-dev-erlang'
    '.hs'                   = 'nf-dev-haskell'
    '.leex'                 = 'nf-custom-elixir'

    # Database
    '.pdb'                  = 'nf-dev-database'
    '.pks'                  = 'nf-dev-database'
    '.pkb'                  = 'nf-dev-database'
    '.accdb'                = 'nf-dev-database'
    '.mdb'                  = 'nf-dev-database'
    '.db'                   = 'nf-seti-db'

    # Source Control
    '.patch'                = 'nf-dev-git'
    '.lock'                 = 'nf-fa-lock'

    # Subtitle files
    '.srt'                  = 'nf-md-file_document'
    '.lrc'                  = 'nf-md-file_document'
    '.ass'                  = 'nf-fa-eye'

    # Documents
    '.chm'                  = 'nf-md-help_box'
    '.pdf'                  = 'nf-fa-file_pdf_o'

    # Excel
    '.xls'                  = 'nf-md-file_excel'
    '.xlsx'                 = 'nf-md-file_excel'

    # PowerPoint
    '.pptx'                 = 'nf-md-file_powerpoint'
    '.ppt'                  = 'nf-md-file_powerpoint'
    '.pptm'                 = 'nf-md-file_powerpoint'
    '.potx'                 = 'nf-md-file_powerpoint'
    '.potm'                 = 'nf-md-file_powerpoint'
    '.ppsx'                 = 'nf-md-file_powerpoint'
    '.ppsm'                 = 'nf-md-file_powerpoint'
    '.pps'                  = 'nf-md-file_powerpoint'
    '.ppam'                 = 'nf-md-file_powerpoint'
    '.ppa'                  = 'nf-md-file_powerpoint'

    # Word
    '.doc'                  = 'nf-md-file_word'
    '.docx'                 = 'nf-md-file_word'
    '.rtf'                  = 'nf-md-file_word'

    # Audio
    '.mp3'                  = 'nf-fa-file_audio_o'
    '.flac'                 = 'nf-fa-file_audio_o'
    '.m4a'                  = 'nf-fa-file_audio_o'
    '.wma'                  = 'nf-fa-file_audio_o'
    '.aiff'                 = 'nf-fa-file_audio_o'
    '.wav'                  = 'nf-fa-file_audio_o'
    '.aac'                  = 'nf-fa-file_audio_o'
    '.opus'                 = 'nf-fa-file_audio_o'

    # Images
    '.ami'                  = 'nf-fa-file_image_o'
    '.apx'                  = 'nf-fa-file_image_o'
    '.bmp'                  = 'nf-fa-file_image_o'
    '.bpg'                  = 'nf-fa-file_image_o'
    '.brk'                  = 'nf-fa-file_image_o'
    '.cur'                  = 'nf-fa-file_image_o'
    '.dds'                  = 'nf-fa-file_image_o'
    '.dng'                  = 'nf-fa-file_image_o'
    '.eps'                  = 'nf-fa-file_image_o'
    '.exr'                  = 'nf-fa-file_image_o'
    '.fpx'                  = 'nf-fa-file_image_o'
    '.gbr'                  = 'nf-fa-file_image_o'
    '.gif'                  = 'nf-md-file_gif_box'
    '.ico'                  = 'nf-fa-file_image_o'
    '.jb2'                  = 'nf-fa-file_image_o'
    '.jbig2'                = 'nf-fa-file_image_o'
    '.jng'                  = 'nf-fa-file_image_o'
    '.jpeg'                 = 'nf-fa-file_image_o'
    '.jpg'                  = 'nf-fa-file_image_o'
    '.jxr'                  = 'nf-fa-file_image_o'
    '.pbm'                  = 'nf-fa-file_image_o'
    '.pgf'                  = 'nf-fa-file_image_o'
    '.pic'                  = 'nf-fa-file_image_o'
    '.png'                  = 'nf-fa-file_image_o'
    '.psb'                  = 'nf-fa-file_image_o'
    '.psd'                  = 'nf-fa-file_image_o'
    '.raw'                  = 'nf-fa-file_image_o'
    '.svg'                  = 'nf-md-svg'
    '.tif'                  = 'nf-fa-file_image_o'
    '.tiff'                 = 'nf-fa-file_image_o'
    '.webp'                 = 'nf-fa-file_image_o'

    # Video
    '.webm'                 = 'nf-fa-file_video_o'
    '.mkv'                  = 'nf-fa-file_video_o'
    '.flv'                  = 'nf-fa-file_video_o'
    '.vob'                  = 'nf-fa-file_video_o'
    '.ogv'                  = 'nf-fa-file_video_o'
    '.ogg'                  = 'nf-fa-file_video_o'
    '.gifv'                 = 'nf-fa-file_video_o'
    '.avi'                  = 'nf-fa-file_video_o'
    '.mov'                  = 'nf-fa-file_video_o'
    '.qt'                   = 'nf-fa-file_video_o'
    '.wmv'                  = 'nf-fa-file_video_o'
    '.yuv'                  = 'nf-fa-file_video_o'
    '.rm'                   = 'nf-fa-file_video_o'
    '.rmvb'                 = 'nf-fa-file_video_o'
    '.mp4'                  = 'nf-fa-file_video_o'
    '.mpg'                  = 'nf-fa-file_video_o'
    '.mp2'                  = 'nf-fa-file_video_o'
    '.mpeg'                 = 'nf-fa-file_video_o'
    '.mpe'                  = 'nf-fa-file_video_o'
    '.mpv'                  = 'nf-fa-file_video_o'
    '.m2v'                  = 'nf-fa-file_video_o'

    # Email
    '.ics'                  = 'nf-fa-calendar'

    # Certificates
    '.cer'                  = 'nf-fa-certificate'
    '.cert'                 = 'nf-fa-certificate'
    '.crt'                  = 'nf-fa-certificate'
    '.pfx'                  = 'nf-fa-certificate'

    # Disk Image
    '.vmdk'                 = 'nf-md-harddisk'
    '.vhd'                  = 'nf-md-harddisk'
    '.vhdx'                 = 'nf-md-harddisk'
    '.img'                  = 'nf-fae-disco'
    '.iso'                  = 'nf-fae-disco'

    # Keys
    '.pem'                  = 'nf-fa-key'
    '.pub'                  = 'nf-fa-key'
    '.key'                  = 'nf-fa-key'
    '.asc'                  = 'nf-fa-key'
    '.gpg'                  = 'nf-fa-key'

    # Fonts
    '.woff'                 = 'nf-fa-font'
    '.woff2'                = 'nf-fa-font'
    '.ttf'                  = 'nf-fa-font'
    '.eot'                  = 'nf-fa-font'
    '.suit'                 = 'nf-fa-font'
    '.otf'                  = 'nf-fa-font'
    '.bmap'                 = 'nf-fa-font'
    '.fnt'                  = 'nf-fa-font'
    '.odttf'                = 'nf-fa-font'
    '.ttc'                  = 'nf-fa-font'
    '.font'                 = 'nf-fa-font'
    '.fonts'                = 'nf-fa-font'
    '.sui'                  = 'nf-fa-font'
    '.ntf'                  = 'nf-fa-font'
    '.mrg'                  = 'nf-fa-font'

    # Visual Studio
    '.csproj'               = 'nf-dev-visualstudio'
    '.ruleset'              = 'nf-dev-visualstudio'
    '.sln'                  = 'nf-dev-visualstudio'
    '.slnf'                 = 'nf-dev-visualstudio'
    '.suo'                  = 'nf-dev-visualstudio'
    '.vcxitems'             = 'nf-dev-visualstudio'
    '.vcxitems.filters'     = 'nf-dev-visualstudio'
    '.vcxproj'              = 'nf-dev-visualstudio'
    '.vsxproj.filters'      = 'nf-dev-visualstudio'
    '.user'                 = 'nf-dev-visualstudio'

    # VSCode
    '.vscodeignore'         = 'nf-dev-vscode'
    '.vsixmanifest'         = 'nf-dev-vscode'
    '.vsix'                 = 'nf-dev-vscode'
    '.code-workspace'       = 'nf-dev-vscode'
    '.code-snippets'        = 'nf-dev-vscode'

    # Sublime
    '.sublime-project'      = 'nf-dev-sublime'
    '.sublime-workspace'    = 'nf-dev-sublime'

    # Autodesk Inventor
    '.iLogicVb'             = 'nf-md-alpha_i'
  }
  FileName      = @{
    '_viminfo'                      = 'nf-dev-vim'
    '_vimrc'                        = 'nf-dev-vim'
    '.azure-pipelines.yml'          = 'nf-md-microsoft_azure'
    '.bash_login'                   = 'nf-dev-bash'
    '.bash_logout'                  = 'nf-dev-bash'
    '.bash_profie'                  = 'nf-dev-bash'
    '.bashrc'                       = 'nf-dev-bash'
    '.buildignore'                  = 'nf-cod-gear'
    '.clang-format'                 = 'nf-cod-gear'
    '.clang-tidy'                   = 'nf-cod-gear'
    '.DS_Store'                     = 'nf-fa-file_o'
    '.eslintrc.json'                = 'nf-dev-eslint'
    '.eslintrc'                     = 'nf-dev-eslint'
    '.gitattributes'                = 'nf-dev-git'
    '.gitconfig'                    = 'nf-dev-git'
    '.gitignore'                    = 'nf-seti-git_ignore'
    '.gitkeep'                      = 'nf-dev-git'
    '.gitlab-ci.yml'                = 'nf-fa-gitlab'
    '.gitmodules'                   = 'nf-dev-git'
    '.ignore'                       = 'nf-seti-git_ignore'
    '.jenkinsfile'                  = 'nf-dev-jenkins'
    '.jshintignore'                 = 'nf-cod-gear'
    '.mrconfig'                     = 'nf-cod-gear'
    '.nvimrc'                       = 'nf-custom-neovim'
    '.prettierignore'               = 'nf-custom-prettier'
    '.prettierrc'                   = 'nf-custom-prettier'
    '.profie'                       = 'nf-seti-shell'
    '.travis.yml'                   = 'nf-dev-travis'
    '.viminfo'                      = 'nf-dev-vim'
    '.vimrc'                        = 'nf-dev-vim'
    '.yardopts'                     = 'nf-cod-gear'
    'AUTHORS.md'                    = 'nf-oct-person'
    'AUTHORS.txt'                   = 'nf-oct-person'
    'AUTHORS'                       = 'nf-oct-person'
    'bash.bashrc'                   = 'nf-dev-bash'
    'bashrc'                        = 'nf-dev-bash'
    'bitbucket-pipelines.yaml'      = 'nf-dev-bitbucket'
    'bitbucket-pipelines.yml'       = 'nf-dev-bitbucket'
    'Cargo.lock'                    = 'nf-custom-toml'
    'CHANGELOG.md'                  = 'nf-fae-checklist_o'
    'CHANGELOG.txt'                 = 'nf-fae-checklist_o'
    'CHANGELOG'                     = 'nf-fae-checklist_o'
    'eslint.config.js'              = 'nf-dev-eslint'
    'eslint.config.ts'              = 'nf-dev-eslint'
    'favicon.ico'                   = 'nf-seti-favicon'
    'git-history'                   = 'nf-dev-git'
    'jenkinsfile'                   = 'nf-dev-jenkins'
    'LICENSE'                       = 'nf-md-certificate'
    'Makefile'                      = 'nf-seti-makefile'
    'manifest.mf'                   = 'nf-cod-gear'
    'README.md'                     = 'nf-fa-readme'
    'README.txt'                    = 'nf-fa-readme'
    'README'                        = 'nf-fa-readme'
    'tsconfig.json'                 = 'nf-seti-tsconfig'
    'tsconfig.node.json'            = 'nf-seti-tsconfig'
    'tsconfig.browser.json'         = 'nf-seti-tsconfig'
    'uv.lock'                       = 'nf-custom-toml'

    # Firebase
    'firebase.json'                 = 'nf-dev-firebase'
    '.firebaserc'                   = 'nf-dev-firebase'

    # Bower
    '.bowerrc'                      = 'nf-dev-bower'
    'bower.json'                    = 'nf-dev-bower'

    # Conduct
    'code_of_conduct.md'            = 'nf-fa-handshake_o'
    'code_of_conduct.txt'           = 'nf-fa-handshake_o'

    # Docker
    'Dockerfile'                    = 'nf-dev-docker'
    'docker-compose.yml'            = 'nf-dev-docker'
    'docker-compose.yaml'           = 'nf-dev-docker'
    'docker-compose.dev.yml'        = 'nf-dev-docker'
    'docker-compose.local.yml'      = 'nf-dev-docker'
    'docker-compose.ci.yml'         = 'nf-dev-docker'
    'docker-compose.override.yml'   = 'nf-dev-docker'
    'docker-compose.staging.yml'    = 'nf-dev-docker'
    'docker-compose.prod.yml'       = 'nf-dev-docker'
    'docker-compose.production.yml' = 'nf-dev-docker'
    'docker-compose.test.yml'       = 'nf-dev-docker'

    # Vue
    'vue.config.js'                 = 'nf-md-vuejs'
    'vue.config.ts'                 = 'nf-md-vuejs'

    # Gulp
    'gulpfile.js'                   = 'nf-dev-gulp'
    'gulpfile.ts'                   = 'nf-dev-gulp'
    'gulpfile.babel.js'             = 'nf-dev-gulp'

    # Grunt
    'gruntfile.js'                  = 'nf-seti-grunt'

    # Webpack
    'webpack.config.ts'             = 'nf-dev-webpack'
    'webpack.config.js'             = 'nf-dev-webpack'

    # Vite
    'vite.config.ts'                = 'nf-dev-vitejs'
    'vite.config.js'                = 'nf-dev-vitejs'

    # Vitest
    'vitest.config.ts'              = 'nf-dev-vitest'
    'vitest.config.js'              = 'nf-dev-vitest'

    # NodeJS
    'package.json'                  = 'nf-dev-nodejs'
    '.nvmrc'                        = 'nf-dev-nodejs'

    # NPM
    'package-lock.json'             = 'nf-dev-npm'
    '.nmpignore'                    = 'nf-dev-npm'
    '.npmrc'                        = 'nf-dev-npm'

    # PNPM
    'pnpm-lock.yaml'                = 'nf-dev-pnpm'
    'pnpm-workspace.yaml'           = 'nf-dev-pnpm'

    # Bun
    'bun.lock'                      = 'nf-dev-bun'
    'bun.lockb'                     = 'nf-dev-bun'

    # Deno
    'deno.json'                     = 'nf-dev-denojs'

    # Yarn
    'yarn.lock'                     = 'nf-dev-yarn'

    # Terraform
    '.terraform.lock.hcl'           = 'nf-fa-lock'

    # Gradle
    'gradlew'                       = 'nf-md-elephant'
    'gradlew.bat'                   = 'nf-md-elephant'
    'gradle.kts'                    = 'nf-md-elephant'
  }
}
