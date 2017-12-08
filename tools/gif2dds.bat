@echo off
cls

set inputFile=%1
set convertedName=%2

if not exist ".\converted" mkdir ".\converted"
if not exist ".\converted\%convertedName%" mkdir ".\converted\%convertedName%"
del /Q ".\converted\%convertedName%\*"

magick convert -coalesce -define dds:compression=dxt5 "%inputFile%" ".\converted\%convertedName%\%convertedName%_%%d.dds"
