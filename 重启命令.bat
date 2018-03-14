::tasklist | find  "aam2_client.exe" || (taskkill aam2_client.exe && exit)
::taskkill /im aam2_client.exe /f

::tasklist -v | findstr "aam2_client.exe" || (taskkill aam2_client.exe exit)
::
::aam2_client.exe
::
::exit


tasklist | find /i "aam2_client.exe" && (taskkill /F /IM aam2_client.exe)

aam2_client.exe

exit

