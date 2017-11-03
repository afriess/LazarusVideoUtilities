echo this creates the documentation
echo ----------------------
echo the old contend is deleted first !!
echo ----------------------
echo You can use break yet, if you dont want this 
pause
if not exist help\doc\nul mkdir help\doc
del help\doc\*.chm
del help\doc\*.hhc
del help\doc\*.hhk
del help\doc\*.hhp
del help\doc\*.htm*
del help\doc\*.gif
del help\doc\*.log
pause
help\diPasDoc_console.exe -OHtmlHelp -Le -Chelp\HhcContents.txt -Ehelp\doc -I.\src\DSPack -T"Progdigy DSPack Components v2.3.3" -Shelp\files.txt
pause
