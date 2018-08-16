# Tetris - a Tetris clone wirtten in PowerShell.
# Copyright (C) 2018 - jdgregson
# License: GNU GPLv3
# Authors: jdgregson <jdgregson@gmail.com>

$script_dir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module $script_dir\psui1.psm1 -Force

$activePiece = $Null
$nextPiece = $Null
$lastRotation = 0
$BACKGROUND_COLOR = (Get-Host).UI.RawUI.BackgroundColor
$colors = "DarkBlue","DarkGreen","DarkRed","DarkMagenta","DarkYellow","Magenta","Blue"
$pieces = @(
    @(
        @(1,1,1,1,0,0,0,0,6,4),
        @(0,1,0,1,0,1,0,1,6,2),
        @(1,1,1,1,0,0,0,0,6,4),
        @(0,1,0,1,0,1,0,1,6,2)
    ),
    @(
        @(1,1,0,0,1,1,0,0,2,4),
        @(1,1,0,0,1,1,0,0,2,4),
        @(1,1,0,0,1,1,0,0,2,4),
        @(1,1,0,0,1,1,0,0,2,4)
    ),
    @(
        @(0,1,0,0,1,1,1,0,4,4),
        @(1,0,1,1,1,0,0,0,4,2),
        @(1,1,1,0,0,1,0,0,4,4),
        @(0,1,1,1,0,1,0,0,4,2)
    ),
    @(
        @(1,1,0,0,0,1,1,0,1,4),
        @(0,1,1,1,1,0,0,0,1,2),
        @(1,1,0,0,0,1,1,0,1,4),
        @(0,1,1,1,1,0,0,0,1,2)
    ),
    @(
        @(1,1,1,0,0,0,1,0,3,4),
        @(0,1,0,1,1,1,0,0,3,2),
        @(1,0,0,0,1,1,1,0,3,4),
        @(1,1,1,0,1,0,0,0,3,2)
    ),
    @(
        @(0,1,1,0,1,1,0,0,0,4),
        @(1,0,1,1,0,1,0,0,0,2),
        @(0,1,1,0,1,1,0,0,0,4),
        @(1,0,1,1,0,1,0,0,0,2)
    ),
    @(
        @(1,1,1,0,1,0,0,0,5,4),
        @(1,1,0,1,0,1,0,0,5,2),
        @(0,0,1,0,1,1,1,0,5,4),
        @(1,0,1,0,1,1,0,0,5,2)
    )
)

function main {
    Draw-MainUI
    while($True) {
        $activePiece = if($nextPiece) {$nextPiece} else {(Get-RandomPiece)}
        $nextPiece = (Get-RandomPiece)
        Draw-GamePiece $nextPiece.piece 1 ((Get-UIConsoleWidth) - 12) ((Get-UIConsoleHeight) - 7)
        while($True) {
            Sleep 0.6
            Read-UserInput
            Update-ActivePiece
        }
    }
}


function Read-UserInput {
    while($Host.UI.RawUI.KeyAvailable) {
        $key = ($host.ui.RawUI.ReadKey("NoEcho,IncludeKeyUp")) -Split ","
        $keyCode = $key[0]
        $keyChar = $key[1]

        # Print the key character and key code for debugging
        Set-UICursorPosition -x ((Get-UIConsoleWidth) - 15) -y 1
        if($keyCode -ne 13) {Write-Host "Key: $keyChar ($keyCode)"}

        if($keyCode) {
            # Up Arrow
            if($keyCode -eq 38) {
                if($activePiece.rotation -lt 3) {
                    $activePiece.rotation += 1
                } else {
                    $activePiece.rotation = 1
                }
            }
        }
    }
}


function Update-ActivePiece {
    if($activePiece) {
        $activePiece.top += 1
        Draw-GamePiece -Erase $True $activePiece.piece $lastRotation $activePiece.left ($activePiece.top -1)
        Draw-GamePiece $activePiece.piece $activePiece.rotation $activePiece.left $activePiece.top
        $script:lastRotation = $activePiece.rotation
    }
}


function Draw-MainUI {
    Reset-UIBufferSize
    Clear-Host
    Write-UITitleLine "Tetris"
    Write-UIBorder -StartY 1 -Height (Get-UIConsoleHeight - 4)
    Write-UIBorder -StartY 1 -StartX ((Get-UIConsoleWidth) - 20) -Height (Get-UIConsoleHeight - 4)
    Write-UIBorder -StartY 1 -StartX (Get-UIConsoleWidth) -Height (Get-UIConsoleHeight - 4)
    Write-UIBorder -StartY (Get-UIConsoleHeight - 3) -Width (Get-UIConsoleWidth)
}


function Draw-GamePiece {
    Param(
        [Parameter(Mandatory=$true)]
        [int]$Piece,
        [int]$Rotate = 0,
        [int]$StartX = 0,
        [int]$StartY = 0,
        [bool]$Erase = $False
    )

    $p = $pieces[$Piece][$Rotate]
    $c = $colors[$p[8]]
    $mod = $p[9]

    if($Erase) {
        $c = $BACKGROUND_COLOR
    }

    $saved_position = (Get-Host).UI.RawUI.CursorPosition
    Set-UICursorPosition $StartX $StartY
    for($i=0; $i -lt 8; $i++) {
        if($p[$i] -eq 1) {
            Write-UIColoredText "  " -BackgroundColor $c
        } else {
            Write-UIText "  "
        }
        if((($i + 1) % $mod) -eq 0) {
            Set-UICursorPosition $StartX (++$StartY)
        }
    }
    (Get-Host).UI.RawUI.CursorPosition = $saved_position
}


function Get-RandomPiece {
    return @{
        piece = $(Get-Random -Min 0 -Max 7);
        rotation = 0;
        top = 1;
        left = (((Get-UIConsoleWidth) - 22) / 2);
    }
}

main
