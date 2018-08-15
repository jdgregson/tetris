
# psui1 - a text-based user interface module for PowerShell
# Copyright (C) 2018 - jdgregson
# License: GNU GPLv3


Set-Alias -Name "Pause-UI" -Value "Wait-AnyKey"
$script:ui_menu_selected_line = 0
$UI_CHAR_BORDER_BOTTOM = "_"


function Get-UIBlockChar {
    if($script:ui_block_char) {
        return $script:ui_block_char
    } else {
        return " "
    }
}


function Set-UIBlockChar {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$character
    )

    $script:ui_block_char = $character
}


function Get-UIConsoleWidth {
    return (Get-Host).UI.RawUI.WindowSize.Width
}


function Get-UIConsoleHeight {
    return (Get-Host).UI.RawUI.WindowSize.Height
}


function Get-UIPSVersion {
    return $PSVersionTable.PSVersion.Major
}


function Write-UIText {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$message
    )

    [System.Console]::Write($message);
}


function Write-UIColoredText {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$message,
        [string]$BackgroundColor = (Get-Host).UI.RawUI.BackgroundColor,
        [string]$ForegroundColor = (Get-Host).UI.RawUI.ForegroundColor
    )

    $saved_background_color = (Get-Host).UI.RawUI.BackgroundColor
    $saved_foreground_color = (Get-Host).UI.RawUI.ForegroundColor
    (Get-Host).UI.RawUI.ForegroundColor = $ForegroundColor
    (Get-Host).UI.RawUI.BackgroundColor = $BackgroundColor
    [System.Console]::Write($message);
    (Get-Host).UI.RawUI.ForegroundColor = $saved_foreground_color
    (Get-Host).UI.RawUI.BackgroundColor = $saved_background_color
}


function Wait-AnyKey {
    cmd /c pause
}


function Write-UIBox {
    Param(
        [int]$count = 1
    )

    if($count -gt 0) {
        Write-UITextInverted $((Get-UIBlockChar) * $count)
    }
}


function Reset-UIBufferSize {
    Set-UIBufferSize (Get-UIConsoleWidth)
}


function Write-UITextInverted {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$message
    )

    $saved_background_color = (Get-Host).UI.RawUI.BackgroundColor
    $saved_foreground_color = (Get-Host).UI.RawUI.ForegroundColor
    (Get-Host).UI.RawUI.ForegroundColor = $saved_background_color
    (Get-Host).UI.RawUI.BackgroundColor = $saved_foreground_color
    [System.Console]::Write($message);
    (Get-Host).UI.RawUI.ForegroundColor = $saved_foreground_color
    (Get-Host).UI.RawUI.BackgroundColor = $saved_background_color
}


function Write-UIWrappedText {
    Param(
        [string]$text = "",
        [bool]$wrap_anywhere = $False,
        [int]$width = (Get-UIConsoleWidth),
        [int]$MaxLines = 0
    )

    if($wrap_anywhere) {
        $split = $text -Split ""
        $join = ""
    } else {
        $split = $text -Split " "
        $join = " "
    }
    $finished = $false
    $i = 0
    $written_lines = 0;
    while($text -and (-not $finished) -and (-not ($MaxLines -gt 0 -and $written_lines -ge $MaxLines))) {
        Write-UIBox 3
        $out_line = ""
        for(; $i -lt $split.Count; $i++) {
            if(($split[$i].length + 3) -ge (Get-UIConsoleWidth)) {
                $split[$i] = $split[$i].substring(0, ((Get-UIConsoleWidth) - 8)) + "..."
            }
            if(($out_line.length + 3 + ($split[$i]).length) -lt $width) {
                $out_line += ($split[$i]) + $join
                $finished = $True
            } else {
                $finished = $False
                break
            }
        }
        Write-UITextInverted $out_line
        $written_lines++
        Write-UIBox $($width - ($out_line.length + 3))
        Write-UINewLine
    }
}


function Write-UITitleLine {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$title
    )

    Write-UIWrappedText $title
}


function Write-UIBlankLine {
    Param(
        [int]$count = 1
    )

    for($i=0; $i -lt $count; $i++) {
        Write-UIBox (Get-UIConsoleWidth)
        Write-UINewLine
    }
}


function Write-UINewLine {
    Param(
        [bool]$force = $False
    )

    if((Get-UIPSVersion) -eq 5 -or $force -eq $True) {
        [System.Console]::Write("`n")
    }
}


function Set-UICursorOffset {
    Param(
        [int]$x = 0,
        [int]$y = 0
    )

    $saved_position = (Get-Host).UI.RawUI.CursorPosition
    $saved_position.X = $saved_position.X + $x
    $saved_position.Y = $saved_position.Y + $y
    (Get-Host).UI.RawUI.CursorPosition = $saved_position
}


function Set-UICursorPosition {
    Param(
        [int]$x = 0,
        [int]$y = 0
    )

    $saved_position = (Get-Host).UI.RawUI.CursorPosition
    $saved_position.X = $x
    $saved_position.Y = $y
    (Get-Host).UI.RawUI.CursorPosition = $saved_position
}


function Get-UICursorPositionX {
    return (Get-Host).UI.RawUI.CursorPosition.X
}


function Get-UICursorPositionY {
    return (Get-Host).UI.RawUI.CursorPosition.Y
}


function Get-UIColorsAtPosition {
    Param(
        [Parameter(Mandatory=$true)]
        [int]$x,
        [Parameter(Mandatory=$true)]
        [int]$y
    )

    $colors = (Get-Host).UI.RawUI.GetBufferContents(@{
        Left=$x; Right=$x; Top=$y; Bottom=$y;
    })
    return @{
        ForegroundColor=$colors.ForegroundColor;
        BackgroundColor=$colors.BackgroundColor;
    }
}


function Set-UIBufferSize {
    Param(
        [int]$width = 0,
        [int]$height = 0
    )

    $saved_buffer = (Get-Host).UI.RawUI.BufferSize
    if(-not($width -eq 0)) {
        $saved_buffer.Width = $width
    }
    if(-not($height -eq 0)) {
        $saved_buffer.Height = $height
    }
    (Get-Host).UI.RawUI.BufferSize = $saved_buffer
}


function Read-UIPrompt {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$title,
        [Parameter(Mandatory=$true)]
        [string]$text,
        [Parameter(Mandatory=$true)]
        [string]$prompt
    )

    Reset-UIBufferSize
    Set-UICursorPosition 0 0
    Write-UITitleLine $title
    Write-UIBlankLine
    Write-UIWrappedText $text
    Write-UIBlankLine
    Write-UIBlankLine
    Write-UIBlankLine
    Write-UIText $(($UI_CHAR_BORDER_BOTTOM) * (Get-UIConsoleWidth))
    Set-UICursorOffset 0 -3
    Write-UIBox 4
    Write-UITextInverted "$prompt`: "
    return Read-Host
}


function Write-UIError {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$message,
        [string]$title = "Error"
    )

    Reset-UIBufferSize
    Set-UICursorPosition 0 0
    $saved_background_color = (Get-Host).UI.RawUI.BackgroundColor
    $saved_foreground_color = (Get-Host).UI.RawUI.ForegroundColor
    (Get-Host).UI.RawUI.ForegroundColor = "White"
    (Get-Host).UI.RawUI.BackgroundColor = "DarkRed"
    Write-UITitleLine $title
    Write-UIBlankLine
    Write-UIWrappedText $message
    Write-UIBlankLine
    Write-UIBlankLine
    Write-UIBlankLine
    Set-UICursorOffset 0 -2
    Write-UIBox 3
    (Get-Host).UI.RawUI.ForegroundColor = $saved_foreground_color
    (Get-Host).UI.RawUI.BackgroundColor = $saved_background_color
    Wait-AnyKey
}


function Write-UIMenuItem {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$title,
        [bool]$selected = $False,
        [int]$width = (Get-UIConsoleWidth)
    )

    Write-UIBox
    if($title.length -gt ($width - 5)) {
        $title = $title.Substring(0, ($width - 8)) + "..."
    }
    Write-UIText "  "
    if($selected) {
        Write-UITextInverted $title
        $script:ui_menu_selected_line = (Get-Host).UI.RawUI.CursorPosition.Y
    } else {
        Write-UIText $title
    }
    Write-UIText (" " * ($width - ($title.length) - 4))
    Write-UIBox
    Write-UINewLine
}


function Update-UISelectedMenuItem {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$old_title,
        [Parameter(Mandatory=$true)]
        [string]$new_title,
        [Parameter(Mandatory=$true)]
        [int]$direction
    )

    Set-UICursorPosition 0 $script:ui_menu_selected_line
    Write-UIMenuItem $old_title
    Set-UICursorPosition 0 ($script:ui_menu_selected_line + $direction)
    Write-UIMenuItem $new_title $True
}
