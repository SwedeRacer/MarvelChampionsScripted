#!/usr/bin/env pwsh
# Sanitizes the Cardpool_Data file to remove control characters and replace Unicode with ASCII equivalents
# Usage: .\sanitize-text.ps1

param()

# Always sanitize the Cardpool_Data file
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$InputFile = Join-Path $scriptDir ".." "mod" "src" "MarvelChampionsLCG" "Cardpool_Data.843931.lua" | Resolve-Path
$OutputFile = $InputFile

# Read the file
$content = Get-Content $InputFile -Raw -Encoding UTF8

Write-Host "Sanitizing Cardpool_Data file: $InputFile"
Write-Host "Original length: $($content.Length) characters"

# Remove BOM if present
$content = $content.TrimStart([char]0xFEFF)

# Replace common Unicode characters with ASCII equivalents
$replacements = @{
    # Dashes
    [char]0x2014 = '-'    # Em dash —
    [char]0x2013 = '-'    # En dash –
    [char]0x2212 = '-'    # Minus sign −
    
    # Quotes
    [char]0x2018 = "'"    # Left single quote '
    [char]0x2019 = "'"    # Right single quote '
    [char]0x201C = '"'    # Left double quote "
    [char]0x201D = '"'    # Right double quote "
    
    # Other punctuation
    [char]0x2026 = '...'  # Ellipsis …
    [char]0x2022 = '*'    # Bullet •
    [char]0x00B7 = '*'    # Middle dot ·
    
    # Arrows
    [char]0x2192 = '->'   # Rightward arrow →
    [char]0x2190 = '<-'   # Leftward arrow ←
    
    # Musical notes (if any)
    [char]0x266B = '[music]'  # Beamed eighth notes ♫
    [char]0x266A = '[music]'  # Eighth note ♪
}

foreach ($char in $replacements.Keys) {
    $replacement = $replacements[$char]
    $count = ($content.Split($char.ToString())).Count - 1
    if ($count -gt 0) {
        Write-Host "  Replacing $count instance(s) of '$char' with '$replacement'"
        $content = $content.Replace($char.ToString(), $replacement)
    }
}

# Remove any control characters (bytes 1-31) except tab (9), LF (10), and CR (13)
$bytes = [System.Text.Encoding]::UTF8.GetBytes($content)
$cleanBytes = New-Object System.Collections.Generic.List[byte]
$removedCount = 0

for ($i = 0; $i -lt $bytes.Length; $i++) {
    $b = $bytes[$i]
    
    # Keep all normal characters and allowed control chars
    if ($b -ge 32 -or $b -eq 9 -or $b -eq 10 -or $b -eq 13) {
        $cleanBytes.Add($b)
    } else {
        # Skip control character
        $removedCount++
    }
}

if ($removedCount -gt 0) {
    Write-Host "  Removed $removedCount control character(s)"
    $content = [System.Text.Encoding]::UTF8.GetString($cleanBytes.ToArray())
}

Write-Host "Sanitized length: $($content.Length) characters"

# Write the sanitized content (UTF-8 without BOM)
[System.IO.File]::WriteAllText($OutputFile, $content, (New-Object System.Text.UTF8Encoding($false)))

Write-Host "Saved to: $OutputFile"
Write-Host "Done!"
