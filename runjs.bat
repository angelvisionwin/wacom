@set @junk=1 /* harmless set command starts commenting batch file commands when the file is used as javascript source
@echo off
setlocal
REM Run the 64-bit version of cscript
set APP=cscript

call %APP% //nologo //E:jscript test.js %* > WacomSign.txt
rem pause
goto :eof