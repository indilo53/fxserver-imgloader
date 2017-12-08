@echo off
cls

for /l %%v in (1, 1, %1) do (
	copy /b ".\stream\imgloader.gfx" ".\stream\imgloader_%%v.gfx" 
)