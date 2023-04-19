# ~/.profile.ps1
#
# PS> Set-ExecutionPolicy RemoteSigned
#
# this file is loaded by 
# %UserProfile%\'My Documents'\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
#
# $script = "$Home\.profile.ps1"
#
# if (Test-Path $script) {
# 	. $script
# }

# terraformの設定
# $Env:TF_LOG = 'DEBUG'
# $Env:TF_LOG_PATH = './terraform.log'

# ターミナルの基本操作系の設定
Set-PsReadlineOption -EditMode vi
Set-PSReadlineKeyHandler -Key 'Ctrl+h' -Function BackwardDeleteChar
Set-PSReadlineKeyHandler -Key 'Ctrl+[' -Function ViCommandMode

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
