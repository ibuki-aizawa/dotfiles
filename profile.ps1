# ~/.profile.ps1

if ($host.Name -eq 'ConsoleHost' -and -not $env:NVIM) {
  # 文字コードをutf-8に
  $PSDefaultParameterValues['Get-Content:Encoding'] = 'utf8'
  $null = chcp 65001
  [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
  $OutputEncoding = [System.Text.Encoding]::UTF8
  # chcp 932

  Import-Module PSReadLine

  # ターミナルの基本操作系の設定
  # Set-PsReadlineOption -EditMode vi
  Set-PSReadlineOption -EditMode Emacs
  Set-PSReadlineKeyHandler -Key 'Ctrl+h' -Function BackwardDeleteChar
  Set-PSReadlineKeyHandler -Key 'Ctrl+[' -Function ViCommandMode
  Set-PSReadlineKeyHandler -Key 'Ctrl+d' -Function DeleteChar

  # 音を消す
  Set-PSReadlineOption -BellStyle None

}


# エイリアス
sal vi 'nvim'
sal grep Select-String
sal which Get-Command
sal open explorer.exe

function l { dir $args }
# cd だけでホームディレクトリに移動するように
Remove-Item Alias:cd -Force
function cd {
  if ($args.Length -eq 0) {
    Set-Location ~
  } else {
    Set-Location "$args"
  }
}

# 直前に開いたファイルを開く
function vr { nvim -c "normal '0" $args }

function gs { git status $args }
# gnu diff を使用する
# winget install -e --id GnuWin32.DiffUtils
Remove-Item Alias:diff -Force
function gd { git diff $args }
function ga { git add $args }
function gw { git switch $args }
function push { git push $args }

# 文字コードを指定
# Remove-Item alias:cat -ErrorAction SilentlyContinue
# function cat { Get-Content -Encoding utf8 $args }

# touch っぽいコマンド
function touch {
    foreach ($file in $args) {
        if (Test-Path $file) {
            (Get-Item $file).LastWriteTime = Get-Date
        } else {
            $null = New-Item -ItemType File -Path $file
        }
    }
}

function base64(){
    Param([switch]$encode=$true, [switch]$decode=$false, [Parameter(Mandatory=$true,ValueFromPipeline=$true)][string]$input)
    Begin{}
    Process{
        if($decode){
            $byte = [System.Convert]::FromBase64String($input)
            $txt = [System.Text.Encoding]::Default.GetString($byte)
            echo $txt
        }
        elseif($encode){
            $byte = ([System.Text.Encoding]::Default).GetBytes($input)
            $b64enc = [Convert]::ToBase64String($byte)
            echo $b64enc
        }
    }
    End{}
}
