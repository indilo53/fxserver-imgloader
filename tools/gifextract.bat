@echo off
cls

set inputFile=%1
set convertedName=%2

if not exist ".\extracted" mkdir ".\extracted"
if not exist ".\extracted\%convertedName%" mkdir ".\extracted\%convertedName%"
del /Q ".\extracted\%convertedName%\*"

magick convert -format "png" -coalesce "%inputFile%" ".\extracted\%convertedName%\%convertedName%_%%d.png"
