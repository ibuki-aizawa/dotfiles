# ~/.profile.ps1
#
# undo: <C-x>u
# 1行やり直し: <M-r>
#

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

# PowerShell 7 の判定
if ($PSVersionTable.PSVersion.Major -ge 7) {
  Set-PSReadLineKeyHandler -Chord 'Ctrl+y' -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion()
  }

  Set-PSReadLineKeyHandler -Chord 'Ctrl+j' -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion()
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
  }
}

# エイリアス
sal vi 'nvim'
sal which Get-Command
sal open explorer.exe

if (Get-Command rg -ErrorAction SilentlyContinue) {
  sal grep rg
} else {
  sal grep Select-String
}

function l { dir $args }
# cd だけでホームディレクトリに移動するように
Remove-Item Alias:cd -Force
function cd {
  if ($args.Length -eq 0) {
    Set-Location ~
    if ($?) { dir }
  } else {
    Set-Location "$args"
    if ($?) { dir }
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

Remove-Item Alias:gc -Force
function gc { git commit $args }

Remove-Item Alias:gl -Force
function gl { git log $args }

function push { git push $args }
function pull { git pull $args }
function commit { git commit $args }

if (Test-Path "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe") {
    $script:devenvPath = & "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" -latest -property productPath
    function devenv { & $script:devenvPath $args }
}

# 文字コードを指定
# Remove-Item alias:cat -ErrorAction SilentlyContinue
# function cat { Get-Content -Encoding utf8 $args }

# ページャーを設定
if (Get-Command bat -ErrorAction SilentlyContinue) {
  $env:PAGER = 'bat'
} elseif (Get-Command less -ErrorAction SilentlyContinue) {
  $env:PAGER = 'less'
}

# help 関数を上書き定義
. ~/repo/dotfiles/help.ps1

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

$env:EDITOR = "nvim"
function v {
    param (
        [string]$Search = ""
    )

    $editor = $env:EDITOR
    if ([string]::IsNullOrWhiteSpace($editor)) {
        $editor = "vim"
    }

    # fzfのプレビュー用サブシェル環境 (Windowsならcmd, Unixならsh) に合わせた構文を準備
    $isWin = [System.Environment]::OSVersion.Platform -eq "Win32NT"
    $nullRedirect = if ($isWin) { ">nul 2>&1" } else { ">/dev/null 2>&1" }
    $q = if ($isWin) { '"' } else { "'" }
    $catCmd = if ($isWin) { "type" } else { "cat" }

    # fzfプレビューを高速化するため、pwshは介さずbatの有無を事前に判定しておく
    $batAvailable = [bool](Get-Command bat -ErrorAction SilentlyContinue)
    $viewer = if ($batAvailable) { "bat --color=always --style=numbers" } else { $catCmd }

    if ([string]::IsNullOrEmpty($Search)) {
        $list = @(git ls-files -m -o --exclude-standard 2>$null)

        if ($list.Count -eq 0) {
            & $editor
            return
        }

        # $previewCmd = 'powershell -NoProfile -Command "if (git ls-files --error-unmatch {} 2>$null) { git diff --color=always {} } else { if (Get-Command bat -ErrorAction SilentlyContinue) { bat --color=always --style=numbers {} } else { Get-Content {} } }"'
        # $previewCmd = "echo $q{}$q | git diff --color=always"
        $previewCmd = "git ls-files --error-unmatch $q{}$q $nullRedirect && git diff --color=always $q{}$q"
        # $previewCmd = "git diff --color=always $q{}$q"
        $file = $list | fzf --ansi --preview $previewCmd
    }
    else {
        if (Test-Path -Path $Search -PathType Leaf) {
            & $editor $Search
            return
        }

        $list = @(fd -H -E ".git" --type f -p $Search 2>$null)

        if ($list.Count -eq 0) {
            Write-Host "No matching files found." -ForegroundColor Yellow
            return
        }
        elseif ($list.Count -eq 1) {
            & $editor $list[0]
            return
        }

        $previewCmd = "$viewer $q{}$q"
        $file = $list | fzf --query "$Search " --select-1 --exit-0 --preview $previewCmd
    }

    if (-not [string]::IsNullOrWhiteSpace($file)) {
        # [string]にキャストして Replace(string, string) のオーバーロードを呼び出す
        $cleanFile = $file.Replace([string][char]0xFEFF, "").Trim()
        & $editor $cleanFile
    }
}

function time {
    if ($args.Count -eq 0) {
        Write-Host "使い方: time { <処理> } または time <コマンド> [引数...]" -ForegroundColor Yellow
        return
    }

    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        if ($args[0] -is [scriptblock]) {
            # time { Get-Process } のように波かっこで渡された場合
            & $args[0]
        } else {
            # time ping google.com のように直接コマンドが渡された場合
            & $args[0] $args[1..($args.Count - 1)]
        }
    } finally {
        $sw.Stop()
        $sec = $sw.Elapsed.TotalSeconds.ToString("F3")
        Write-Host "\`nreal    ${sec}s" -ForegroundColor Yellow
        # Write-Host "`nreal    ${sec}s" -ForegroundColor Yellow
    }
}
