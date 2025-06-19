# ~/.profile.ps1

# ターミナルの基本操作系の設定
Set-PsReadlineOption -EditMode vi
Set-PSReadlineKeyHandler -Key 'Ctrl+h' -Function BackwardDeleteChar
Set-PSReadlineKeyHandler -Key 'Ctrl+[' -Function ViCommandMode

# 音を消す
Set-PSReadlineOption -BellStyle None

# エイリアス
sal vi 'vim'
sal ow 'start-process'
sal grep Select-String
sal which gcm

# touch っぽいコマンド
function touch {
	$args.GetType()
	foreach($i in $args) {
		new-item -type file $i
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
