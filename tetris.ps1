# Tetris - a Tetris clone wirtten in PowerShell.
# Copyright (C) 2018 - jdgregson
# License: GNU GPLv3
# Authors: jdgregson <jdgregson@gmail.com>

Import-Module $script_dir\psui1.psm1 -Force

$colors = "DarkBlue","DarkGreen","DarkRed","DarkMagenta","DarkYellow","Magenta"
$pieces = @(
    @(1,1,0,0,1,1,0,0,2),
    @(0,1,0,0,1,1,1,0,4),
    @(1,1,0,0,0,1,1,0,1),
    @(1,1,1,0,0,0,1,0,3),
    @(0,1,1,0,1,1,0,0,0),
    @(1,1,1,0,1,0,0,0,5)
)


function main {

}


main()
