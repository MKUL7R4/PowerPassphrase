$Graphic = @"
    ____                          ____                        __                       
   / __ \____ _      _____  _____/ __ \____ _______________  / /_  _________ _________ 
  / /_/ / __ \ | /| / / _ \/ ___/ /_/ / __ `/ ___/ ___/ __ \/ __ \/ ___/ __ `/ ___/ _ \
 / ____/ /_/ / |/ |/ /  __/ /  / ____/ /_/ (__  |__  ) /_/ / / / / /  / /_/ (__  )  __/
/_/    \____/|__/|__/\___/_/  /_/    \__,_/____/____/ .___/_/ /_/_/   \__,_/____/\___/ 
                                                   /_/                                 
"@

<#
.SYNOPSIS
Generate secure passphrases offline.
.DESCRIPTION
-Options:
    -Number of words
    -Seperator character
    -Add a number
    -Add a special character
	-Add an uppercase word
    -Re-roll
-Calculates passphrase entropy (strength)
#>

#region Parameters
$ScriptName = "PowerPassphrase.ps1"
$Version = "1.21"
$LastModified = "12/24/2025"
$Author = "Matt Karwoski"
$VerbosePreference = "Continue" # Default = "SilentlyContinue"
$ErrorActionPreference = "SilentlyContinue" # Default = "Continue"
$WarningPreference = "Continue" # Default = "Continue"
$ErrorView = "NormalView" # Default = "NormalView"
$ConfirmPreference = "None" # Default = "High"
$PSDefaultParameterValues["Write-Host:ForegroundColor"] = "Green"
$PSDefaultParameterValues["Write-Host:BackgroundColor"] = "Black"
$Host.UI.RawUI.WindowTitle = "$ScriptName"
#endregion

Function Write-Animation {
<#
.SYNOPSIS
    Animates a Write-Host output, with options to write vertically, change the write speed (time), and make text rainbow colored.
.NOTES
    Name: Write-Animation
    Author: Matt Karwoski
    Version: 1.0
    DateCreated: 8-21-25
.DESCRIPTION
    Parameters:
    Object - the message to animate
    FGColor - foreground color
    BGColor - background color
    Vertical - writes text vertically instead of horizontally
    Rainbow - writes foregroundcolor in rainbow colors
    Time - total time (ms) it takes for the whole string to print
.EXAMPLE
    Write-Animation "THE SKY IS FALLING!" -Vertical -Time 3000
    Write-Animation "My favorite track in Mario Kart is Rainbow Road!!!" -Rainbow -Time 250
    Write-Animation "Wake up, Neo..." -FGColor Green -BGColor Black -Time 2500
    Write-Animation -Msg "Add some flair to your scripting experience :)" -FGColor Magenta -BGColor White -Time 250
    Write-Animation -Msg "This is a prime example of everything that you can possibly do with this function." -Vertical -Rainbow -Time 12500
#>
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0
        )]
        [Alias("Msg", "Message")][string]$Object,
        [ValidateScript( {[enum]::GetNames([consolecolor])} )][string]$FGColor = "White",
        [ValidateScript( {[enum]::GetNames([consolecolor])} )][string]$BGColor = "Black",
        [switch]$Vertical,
        [switch]$Rainbow,
        [int]$Time
    )
    BEGIN {
        $Char = 0
        $Length = $Object.Length
        if ($Time) {
            $TimeIncrement = $Time / $Length
        }
        $RainbowColors = @(
            'Red'
            'Yellow'
            'Green'
            'Cyan'
            'Blue'
            'Magenta'
        )
    }
    PROCESS {
        if ($Vertical -and !$Time -and !$Rainbow) {
            do {
                $DisplayChar = $Object[$Char]
                Write-Host "$DisplayChar" -ForegroundColor $FGColor -BackgroundColor $BGColor
                Start-Sleep -Milliseconds 25
                $Char++
            } until ($Char -eq $Length)
        } elseif ($Vertical -and $Time -and !$Rainbow) {
            do {
                $DisplayChar = $Object[$Char]
                Write-Host "$DisplayChar" -ForegroundColor $FGColor -BackgroundColor $BGColor
                Start-Sleep -Milliseconds $TimeIncrement
                $Char++
            } until ($Char -eq $Length)
        } elseif ($Vertical -and $Time -and $Rainbow) {
            $RainbowColorsInt = 0
            [int]$RainbowColorsCount = $RainbowColors.count
            do {
                if ($RainbowColorsInt -eq $RainbowColorsCount) {
                    $RainbowColorsInt = 0
                }
                $DisplayChar = $Object[$Char]
                Write-Host "$DisplayChar" -ForegroundColor $RainbowColors[$RainbowColorsInt] -BackgroundColor $BGColor
                Start-Sleep -Milliseconds $TimeIncrement
                $Char++
                $RainbowColorsInt++
            } until ($Char -eq $Length)
        } elseif ($Time -and !$Vertical -and !$Rainbow) {
            do {
                $DisplayChar = $Object[$Char]
                Write-Host -NoNewLine "$DisplayChar" -ForegroundColor $FGColor -BackgroundColor $BGColor
                Start-Sleep -Milliseconds $TimeIncrement
                $Char++
            } until ($Char -eq $Length)
        } elseif ($Time -and $Rainbow -and !$Vertical) {
            $RainbowColorsInt = 0
            [int]$RainbowColorsCount = $RainbowColors.count
            do {
                if ($RainbowColorsInt -eq $RainbowColorsCount) {
                    $RainbowColorsInt = 0
                }
                $DisplayChar = $Object[$Char]
                Write-Host -NoNewLine "$DisplayChar" -ForegroundColor $RainbowColors[$RainbowColorsInt] -BackgroundColor $BGColor
                Start-Sleep -Milliseconds $TimeIncrement
                $Char++
                $RainbowColorsInt++
            } until ($Char -eq $Length)
        } elseif ($Rainbow -and !$Time -and !$Vertical) {
            $RainbowColorsInt = 0
            [int]$RainbowColorsCount = $RainbowColors.count
            do {
                if ($RainbowColorsInt -eq $RainbowColorsCount) {
                    $RainbowColorsInt = 0
                }
                $DisplayChar = $Object[$Char]
                Write-Host -NoNewLine "$DisplayChar" -ForegroundColor $RainbowColors[$RainbowColorsInt] -BackgroundColor $BGColor
                Start-Sleep -Milliseconds 25
                $Char++
                $RainbowColorsInt++
            } until ($Char -eq $Length)
        } elseif ($Rainbow -and $Vertical -and !$Time) {
            $RainbowColorsInt = 0
            [int]$RainbowColorsCount = $RainbowColors.count
            do {
                if ($RainbowColorsInt -eq $RainbowColorsCount) {
                    $RainbowColorsInt = 0
                }
                $DisplayChar = $Object[$Char]
                Write-Host "$DisplayChar" -ForegroundColor $RainbowColors[$RainbowColorsInt] -BackgroundColor $BGColor
                Start-Sleep -Milliseconds 25
                $Char++
                $RainbowColorsInt++
            } until ($Char -eq $Length)
        } else {
            do {
                $DisplayChar = $Object[$Char]
                Write-Host -NoNewLine "$DisplayChar" -ForegroundColor $FGColor -BackgroundColor $BGColor
                Start-Sleep -Milliseconds 25
                $Char++
            } until ($Char -eq $Length)
        }
    }
    END {
        # This is the end, my friend.
    }
}

function Get-PasswordEntropy {
	param (
		[Parameter(Mandatory=$true)]
		[string]$Password
	)
	
	# Define character sets and their sizes
	$lowercase = 26
	$uppercase = 26
	$digits = 10
	$specialChars = 32 # Common special characters (e.g., !@#$%^&*()_+-=[]{};':"\,.<>/?`~)
	
	# Determine the character range based on characters present in the password
	$characterRange = 0
	if ($Password -match '[a-z]') {
		$characterRange += $lowercase
	}
	if ($Password -match '[A-Z]') {
		$characterRange += $uppercase
	}
	if ($Password -match '[0-9]') {
		$characterRange += $digits
	}
	if ($Password -match '[^a-zA-Z0-9\s]') { # Matches any character that is not a letter, digit, or whitespace
		$characterRange += $specialChars
	}
	
	# Handle cases where no recognized character types are found (e.g., empty password)
	if ($characterRange -eq 0) {
		Write-Warning "No recognized character types found in the password. Entropy cannot be calculated accurately."
		return 0
	}
	
	# Calculate entropy
	$passwordLength = $Password.Length
	$entropy = $passwordLength * ([Math]::Log($characterRange, 2))
	
	return $entropy
}

#region Graphic and Animation
$Graphic
$String1 = "Script Name: $ScriptName"
Write-Host "$String1" -ForegroundColor White -BackgroundColor Blue
$String2 = "Version: $Version"
Write-Host "$String2" -ForegroundColor White -BackgroundColor Blue
$String3 = "Last Modified: $LastModified"
Write-Host "$String3" -ForegroundColor White -BackgroundColor Blue
$String4 = "Author: $Author"
Write-Host "$String4" -ForegroundColor White -BackgroundColor Blue
Write-Host ""
#endregion

# Load word list (static path)
# $WordList = Get-Content -Path "C:\Users\karwosm\Documents\Scripts\!!My Scripts\MagnumOpus🜁🜃🜂🜄\PowerPassphrase\wordlist1.txt"
# Load word list (dynamically find path)
Write-Host "Searching for word list location..."
$CurrentDir = $PSScriptRoot
if ($WordList = Get-Content -Path (Get-ChildItem -Path $CurrentDir -Filter "wordlist1.txt" -Recurse -ErrorAction SilentlyContinue -Force).FullName) {
    # first checks directory which the script is currently running from
} elseif ($WordList = Get-Content -Path (Get-ChildItem -Path "C:\" -Filter "wordlist1.txt" -Recurse -ErrorAction SilentlyContinue -Force).FullName) {
    # expands search to all of C:/
} else {
    Write-Error "Could not find word list. Please define the path manually in the script."
    throw
}
# Define character sets
$Numbers = @('0';'1';'2';'3';'4';'5';'6';'7';'8';'9')
$Specials = @('~';'!';'@';'#';'$';'%';'^';'&';'*';'(';')';'+';'=';'{';'}';'[';']';'/';'\';'<';'>';'?')

Write-Animation "Choose your passphrase options:" -FGColor Cyan
Write-Host ""
do {
    [int]$WordCount = Read-Host "Number of words (2 or more)"
} until ($WordCount -ge 2)
$Sep = Read-Host "Separating character ('-' '_' '.' ',' ':' ';')"
[array]$SepArray = @('-';'_';'.';',';':';';')
if ($SepArray -contains $Sep) {} else {
    $Sep = '-'
}
do {
    $AddNumber = Read-Host "Add a number? (y/n)"
} until ($AddNumber -like 'y' -or $AddNumber -like 'n')

do {
    $AddSpecial = Read-Host "Add a special character? (y/n)"
} until ($AddSpecial -like 'y' -or $AddSpecial -like 'n')

do {
    $AddUppercase = Read-Host "Add an uppercase word? (y/n)"
} until ($AddUppercase -like 'y' -or $AddUppercase -like 'n')

do {

    # Get random array of words
    [array]$Words = @()
    foreach ($i in 1..$WordCount) {
        $RandomWord = $WordList | Get-Random
        $Words += $RandomWord
    }

    # Add random number
    if ($AddNumber -like 'y') {
        $RandomNumber = $Numbers | Get-Random
        $RandomIndex = Get-Random -Minimum 0 -Maximum ($Words.Length)
        $Words[$RandomIndex] = $Words[$RandomIndex] + $RandomNumber
    }

    # Add random special character
    if ($AddSpecial -like 'y') {
        $RandomSpecial = $Specials | Get-Random
        $RandomIndex = Get-Random -Minimum 0 -Maximum ($Words.Length)
        $Words[$RandomIndex] = $Words[$RandomIndex] + $RandomSpecial
    }

	# Make random word uppercase
    if ($AddUppercase -like 'y') {
        $RandomIndex = Get-Random -Minimum 0 -Maximum ($Words.Length)
        $Words[$RandomIndex] = ($Words[$RandomIndex]).ToUpper()
    }

    # Build the passphrase
    $Passphrase = $Words -Join "$Sep"

    # Calculate passphrase entropy
    $Entropy = ([math]::Round((Get-PasswordEntropy -Password $Passphrase)))
    if ($Entropy -ge 256) {
        $Strength = "Excellent"
        $Splat = @{ForegroundColor = "Green"; BackgroundColor = "Black"}
    } elseif ($Entropy -ge 128) {
        $Strength = "Good"
        $Splat = @{ForegroundColor = "Cyan"; BackgroundColor = "Black"}
    } elseif ($Entropy -ge 64) {
        $Strength = "Mediocre"
        $Splat = @{ForegroundColor = "Yellow"; BackgroundColor = "Black"}
    } else {
        $Strength = "Poor"
        $Splat = @{ForegroundColor = "Red"; BackgroundColor = "Black"}
    }

    Write-Host "Randomly generated passphrase: " -ForegroundColor Cyan -NoNewline
    Write-Animation $Passphrase -FGColor Yellow
    Write-Host ""
    Write-Host "Passphrase entropy: " -NoNewLine -ForegroundColor Cyan
    Write-Host "$Entropy" @Splat
    Write-Host "Passphrase strength: " -NoNewLine -ForegroundColor Cyan
    Write-Host "$Strength" @Splat
    Write-Host ""

    do {
        $Reroll = Read-Host "Re-roll the passphrase? (y/n)"
        if (($Reroll -eq "y") -or ($Reroll -eq "n")) {
            $Go = $true
        }
        else {
            Write-Error "Invalid input. Please try again."
            $Go = $false
        }
    } until ($Go)

} until ($Reroll -eq "n")

Clear-Host
Clear-Variable -Name "Passphrase"
