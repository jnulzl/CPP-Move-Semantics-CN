@echo off
REM =============================================================
REM  C++ Move Semantics: The Complete Guide - Chinese edition
REM  One-click build script (Windows)
REM
REM  Requires: TeX Live 2026 (bundles latexminted 0.7+) + Python 3
REM  Usage    : double-click this file, or run  build.bat
REM
REM  NOTE: this file is deliberately ASCII-only. Chinese comments in a
REM  .bat file break under cmd.exe unless the file encoding matches the
REM  active code page (GBK/936 on zh-CN Windows). Chinese docs: README.md
REM =============================================================
setlocal EnableExtensions

REM ---- Edit these two paths if your install location differs ----
REM  TEXBIN : TeX Live bin directory (contains xelatex.exe)
REM  PYTHON : Python 3 install root (contains python.exe).
REM           latexminted (minted v3 highlighter) is a Python script, so a
REM           valid python.exe must be findable; put the Python ROOT dir on
REM           PATH, NOT the Scripts subdirectory, and BEFORE the TeX bin dir.
set TEXBIN=D:\ProgramData\texlive\2026\bin\windows
set PYTHON=D:\anaconda3

set "PATH=%PYTHON%;%TEXBIN%;%PATH%"

REM Clear PYTHONPATH: a leftover value makes latexminted load the wrong
REM Python modules, silently degrading code highlighting.
set "PYTHONPATH="

REM =============================================================
REM  [CRITICAL] minted v3 cache directory
REM
REM  latexminted rejects RELATIVE write targets outright, and minted's
REM  default cachedir is the relative "_minted", so every code block
REM  would fail with:
REM      Cannot write file "_xxx.index.minted" outside working directory
REM
REM  book/ccs.tex rewrites \minted@cachedir to the ABSOLUTE project root,
REM  reading its value from the two env vars below (TEXMF_OUTPUT_DIRECTORY
REM  takes priority). They MUST point at the absolute project root.
REM  Do NOT rely on PWD (bash-only) and do not leave them empty.
REM =============================================================
for %%A in ("%~dp0.") do set "TEXMF_OUTPUT_DIRECTORY=%%~fA"
set "TEXMFOUTPUT=%TEXMF_OUTPUT_DIRECTORY%"
echo [build] project root = %TEXMF_OUTPUT_DIRECTORY%

cd /d "%~dp0."

REM minted needs shell escape; TOC/bookmarks need three passes to settle.
xelatex -shell-escape -interaction=nonstopmode -synctex=1 main.tex
if errorlevel 1 goto :err
xelatex -shell-escape -interaction=nonstopmode -synctex=1 main.tex
if errorlevel 1 goto :err
xelatex -shell-escape -interaction=nonstopmode -synctex=1 main.tex
if errorlevel 1 goto :err

REM Highlighting failures do NOT make xelatex return a non-zero exit code,
REM so scan the log explicitly instead of trusting the exit code alone.
findstr /C:"Cannot write file" /C:"Cannot highlight code" main.log >nul 2>&1
if not errorlevel 1 (
  echo.
  echo [WARN] minted highlight failures still present in main.log. Check:
  echo        - is python.exe on PATH?
  echo        - does book/ccs.tex resolve \minted@cachedir to an absolute path?
  goto :err
)

REM Cleanup: *.minted / *.listing are regenerated on the next run.
for %%F in ("%CD%\*.minted") do @del /q "%%~fF" 2>nul
for %%F in ("%CD%\*.listing") do @del /q "%%~fF" 2>nul

echo.
echo Build finished. Output: main.pdf
goto :eof

:err
echo.
echo Build FAILED. See main.log in this directory.
pause
