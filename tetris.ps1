# Tetris - a Tetris clone wirtten in PowerShell.
# Copyright (C) 2018 - jdgregson
# License: GNU GPLv3
# Authors: jdgregson <jdgregson@gmail.com>

$script_dir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module $script_dir\psui1.psm1 -Force

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
    Set-UICursorPosition 2 2

    Draw-GamePiece 0 0 10 10
    Draw-GamePiece 0 1 10 15
    Draw-GamePiece 0 2 10 20
    Draw-GamePiece 0 3 10 25

    Draw-GamePiece 1 0 20 10
    Draw-GamePiece 1 1 20 15
    Draw-GamePiece 1 2 20 20
    Draw-GamePiece 1 3 20 25

    Draw-GamePiece 2 0 30 10
    Draw-GamePiece 2 1 30 15
    Draw-GamePiece 2 2 30 20
    Draw-GamePiece 2 3 30 25

    Draw-GamePiece 3 0 40 10
    Draw-GamePiece 3 1 40 15
    Draw-GamePiece 3 2 40 20
    Draw-GamePiece 3 3 40 25

    Draw-GamePiece 4 0 50 10
    Draw-GamePiece 4 1 50 15
    Draw-GamePiece 4 2 50 20
    Draw-GamePiece 4 3 50 25

    Draw-GamePiece 5 0 60 10
    Draw-GamePiece 5 1 60 15
    Draw-GamePiece 5 2 60 20
    Draw-GamePiece 5 3 60 25


    Wait-AnyKey
    Clear-Host

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
        [int]$StartY = 0
    )

    $p = $pieces[$Piece][$Rotate]
    $c = $colors[$p[8]]
    $mod = $p[9]
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

main
