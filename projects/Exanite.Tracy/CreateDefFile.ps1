$script = {
    # This is very hardcoded right now
    $lib = "..\..\outputs\cache\cmake-user\windows-vs2022-release\install\tracy\lib\TracyClient.lib"
    $output = "src\Exports.def"
    $symbols = dumpbin /SYMBOLS $lib |
        Select-String "External" |
        ForEach-Object { $_.ToString().Split('|')[-1].Trim() } |
        Where-Object { $_ -match '^___tracy' } |
        Select-Object -Unique

    "EXPORTS" | Out-File -FilePath $output
    $symbols |
        Sort-Object |
        ForEach-Object { "    $_" } |
        Out-File -FilePath $output -Append
}

Push-Location -Path $PSScriptRoot
try {
    & $script
}
finally {
    Pop-Location
}
