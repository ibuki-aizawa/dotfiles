# デフォルトの help 関数の定義を基に表示時のタイトル表示を変更する機能を追加
function help {
<#
.FORWARDHELPTARGETNAME Get-Help
.FORWARDHELPCATEGORY Cmdlet
#>
  [CmdletBinding(DefaultParameterSetName='AllUsersView', HelpUri='https://go.microsoft.com/fwlink/?LinkID=113316')]
  param(
      [Parameter(Position=0, ValueFromPipelineByPropertyName=$true)]
      [string]
      ${Name},

      [string]
      ${Path},

      [ValidateSet('Alias','Cmdlet','Provider','General','FAQ','Glossary','HelpFile','ScriptCommand','Function','Filter','ExternalScript','All','DefaultHelp','DscResource','Class','Configuration')]
      [string[]]
      ${Category},

      [Parameter(ParameterSetName='DetailedView', Mandatory=$true)]
      [switch]
      ${Detailed},

      [Parameter(ParameterSetName='AllUsersView')]
      [switch]
      ${Full},

      [Parameter(ParameterSetName='Examples', Mandatory=$true)]
      [switch]
      ${Examples},

      [Parameter(ParameterSetName='Parameters', Mandatory=$true)]
      [string[]]
      ${Parameter},

      [string[]]
      ${Component},

      [string[]]
      ${Functionality},

      [string[]]
      ${Role},

      [Parameter(ParameterSetName='Online', Mandatory=$true)]
      [switch]
      ${Online},

      [Parameter(ParameterSetName='ShowWindow', Mandatory=$true)]
      [switch]
      ${ShowWindow}
    )

    # Display the full help topic by default but only for the AllUsersView parameter set.
    if (($psCmdlet.ParameterSetName -eq 'AllUsersView') -and !$Full) {
        $PSBoundParameters['Full'] = $true
    }

    # Nano needs to use Unicode, but Windows and Linux need the default
    $OutputEncoding = if ([System.Management.Automation.Platform]::IsNanoServer -or [System.Management.Automation.Platform]::IsIoT) {
        [System.Text.Encoding]::Unicode
    } else {
        [System.Console]::OutputEncoding
    }

    $help = Get-Help @PSBoundParameters

    # If a list of help is returned or AliasHelpInfo (because it is small), don't pipe to more
    $psTypeNames = ($help | Select-Object -First 1).PSTypeNames
    if ($psTypeNames -Contains 'HelpInfoShort' -Or $psTypeNames -Contains 'AliasHelpInfo')
    {
        $help
    }
    elseif ($help -ne $null)
    {
        # By default use more on Windows and less on Linux.
        $pagerCommand = 'more.com'
        $pagerArgs = $null

        # Respect PAGER environment variable which allows user to specify a custom pager.
        # Ignore a pure whitespace PAGER value as that would cause the tokenizer to return 0 tokens.
        if (![string]::IsNullOrWhitespace($env:PAGER)) {
            if (Get-Command $env:PAGER -ErrorAction Ignore) {
                # Entire PAGER value corresponds to a single command.
                $pagerCommand = $env:PAGER
                $pagerArgs = $null
            }
            else {
                # PAGER value is not a valid command, check if PAGER command and arguments have been specified.
                # Tokenize the specified $env:PAGER value. Ignore tokenizing errors since any errors may be valid
                # argument syntax for the paging utility.
                $errs = $null
                $tokens = [System.Management.Automation.PSParser]::Tokenize($env:PAGER, [ref]$errs)

                $customPagerCommand = $tokens[0].Content
                if (!(Get-Command $customPagerCommand -ErrorAction Ignore)) {
                    # Custom pager command is invalid, issue a warning.
                    Write-Warning "Custom-paging utility command not found. Ignoring command specified in `$env:PAGER: $env:PAGER"
                }
                else {
                    # This approach will preserve all the pagers args.
                    $pagerCommand = $customPagerCommand
                    $pagerArgs = if ($tokens.Count -gt 1) {
                        $env:PAGER.Substring($tokens[1].Start)
                    }
                    else {
                        $null
                    }
                }
            }
        }

        $originalTitle = $Host.UI.RawUI.WindowTitle
        try {
          $Host.UI.RawUI.WindowTitle = "man $Name"

          $pagerCommandInfo = Get-Command -Name $pagerCommand -ErrorAction Ignore
          if ($pagerCommandInfo -eq $null) {
              $help
          }
          elseif ($pagerCommandInfo.CommandType -eq 'Application') {
              # If the pager is an application, format the output width before sending to the app.
              $consoleWidth = [System.Math]::Max([System.Console]::WindowWidth, 20)

              if ($pagerArgs) {
                  $help | Out-String -Stream -Width ($consoleWidth - 1) | & $pagerCommand $pagerArgs
              }
              else {
                  $help | Out-String -Stream -Width ($consoleWidth - 1) | & $pagerCommand
              }
          }
          else {
              # The pager command is a PowerShell function, script or alias, so pipe directly into it.
              $help | & $pagerCommand $pagerArgs
          }
        } finally {
          $Host.UI.RawUI.WindowTitle = $originalTitle
        }
    }
}
