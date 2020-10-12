function StartTSX {
	[Alias('tsx')]
	[CmdletBinding()]
	param (
		[Parameter(Position=0, Mandatory=$true)]
		[string]
		$ProjectName
    )
    
    $setup_files = 'D:\Codes\setup-files'
    if ((Test-Path $setup_files/.prettierrc) -eq $false) {
        Write-Host '📂❌ Cannot find setup files folder.' -fore red
        return
    }
    
    Add-Type -AssemblyName System.Windows.Forms 
    $global:balloon = New-Object System.Windows.Forms.NotifyIcon
    $path = (Get-Process -id $pid).Path
    $balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path) 
    $balloon.BalloonTipTitle = "TSX $ProjectName"
    $balloon.Visible = $true
    
	Write-Host '🌐⏳ Testing internet connection...' -fore magenta
	if (!(Test-Connection 8.8.8.8 -Count 1 -Quiet)) {
		Write-Host '🌐❌ No internet. Please check your internet connection!' -fore red
		return
	}

	Write-Host '🌐✅ Internet connection active.' -fore green
	Write-Color '📂⏳ Creating new TSX project - ', "$ProjectName", ' ...' -Color magenta, yellow, magenta

	$output = & npm init react-app $ProjectName --template typescript --use-npm 2>&1
	$code = $LASTEXITCODE

	Clear-Host
	Write-Host '🌐✅ Internet connection active.' -fore green

	if (($code -ne 0) -or ((Test-Path ./$ProjectName) -eq $false)) {
        $balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Error
        $balloon.BalloonTipText = '📂❌ There was a problem while trying to create the project. Please try again later.'
        $balloon.ShowBalloonTip(5000)

		$err = $output.Where{$PSITEM -match 'ERR'}
		Write-Host '📂❌ There was a problem while trying to create the project. Please try again later.' -fore red
		Write-Host $err -fore red
		return
	}

	Write-Color '📂✅ New TSX Project ', "$ProjectName", ' created successfully.' -Color green, yellow, green
	Set-Location ./$ProjectName
	Write-Host '👩🏻‍💻⏳ Updating dev dependencies...' -fore magenta

	$output = & npm i -D @testing-library/jest-dom@latest @testing-library/react@latest @testing-library/user-event@latest @types/jest@latest @types/node@latest @types/react@latest @types/react-dom@latest typescript@latest react-scripts@latest 2>&1
	$code = $LASTEXITCODE

	Clear-Host
	Write-Host '🌐✅ Internet connection active.' -fore green
	Write-Color '📂✅ New TSX Project ', "$ProjectName ", 'created successfully.' -Color green, yellow, green

	if ($code -ne 0) {
        $balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Error
        $balloon.BalloonTipText = '👩🏻‍💻❌ There was a problem while trying to update the dev dependencies. Please try again later.'
        $balloon.ShowBalloonTip(5000)

		$err = $output.Where{$PSITEM -match 'ERR'}
		Write-Host '👩🏻‍💻❌ There was a problem while trying to update the dev dependencies. Please try again later.' -fore red
		Write-Host $err -fore red
		return
	}

	Write-Host '👩🏻‍💻✅ Dev dependencies updated successfully.' -fore green
	Write-Host '📦⏳ Updating project dependencies...' -fore magenta
	
	$output = & npm i react@latest react-dom@latest 2>&1
	$code = $LASTEXITCODE

	Clear-Host

	Write-Host '🌐✅ Internet connection active.' -fore green
	Write-Color '📂✅ New TSX Project ', "$ProjectName ", 'created successfully.' -Color green, yellow, green
	Write-Host '👩🏻‍💻✅ Dev dependencies updated successfully.' -fore green

	if ($code -ne 0) {
        $balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Error
        $balloon.BalloonTipText = '📦❌ There was a problem while trying to update the project dependencies. Please try again later.'
        $balloon.ShowBalloonTip(5000)

		$err = $output.Where{$PSITEM -match 'ERR'}
		Write-Host '📦❌ There was a problem while trying to update the project dependencies. Please try again later.' -fore red
		Write-Host $err -fore red
		return
	}

	Write-Host '📦✅ Project dependencies updated successfully.' -fore green

	Write-Host '♻⏳ Removing git commit...' -fore magenta
	git update-ref -d HEAD
	git reset
	Write-Host '♻✅ Git commit removed.' -fore green

	Write-Host '⛔⏳ Adding lock file to .gitignore...' -fore magenta
	"package-lock.json" | Add-Content .gitignore
	Write-Host '⛔✅ Lock file added to .gitignore.' -fore green

	Write-Host '📃⏳ Editing Readme file...' -fore magenta
	"# $ProjectName" | Set-Content README.md
	"Made using my custom TSX command. -Riday 💙" | Add-Content README.md
	Write-Host '📃✅ Readme file edited.' -fore green

	Write-Host '⚙⏳ Configuring VS Code to use prettier...' -fore magenta
	mkdir .vscode | Out-Null
	Copy-Item "$setup_files\settings.json" -Destination '.\.vscode'
	Write-Host '⚙✅ Configured VS Code to use prettier.' -fore green

	Write-Host '🦋⏳ Configuring prettier...' -fore magenta
	Copy-Item "$setup_files\.prettierrc" -Destination '.'
	Write-Host '🦋✅ Configured prettier.' -fore green

    Write-Host '✅ Project is ready!' -fore green
    
    $balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
    $balloon.BalloonTipText = '✅ Project is ready!'
    $balloon.ShowBalloonTip(5000)
}
