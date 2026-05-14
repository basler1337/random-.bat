@echo off
setlocal enabledelayedexpansion

set "WEBHOOK_URL=YOURWEBHOOKURL"
set /a Number=1

:LOOP
cls
echo ============================================================
echo  Discord Number Sender
echo ============================================================
echo  Current Number: %Number%
echo.
echo  [N] Send next Number    [Q] Quit
echo ============================================================
echo.

set "TMP_JSON=%TEMP%\discord_payload.json"
(
    echo {
    echo   "embeds": [{
    echo     "description": "**%Number%**",
    echo     "color": 5763719
    echo   }]
    echo }
) > "%TMP_JSON%"

curl -s -X POST -H "Content-Type: application/json" --data-binary "@%TMP_JSON%" "%WEBHOOK_URL%" -o "%TEMP%\dc_out.txt" -w "%%{http_code}" > "%TEMP%\dc_code.txt" 2>&1

set /p HTTP_CODE=<"%TEMP%\dc_code.txt"

if "%HTTP_CODE%"=="204" (
    echo  [OK] Number %Number% sent successfully!
) else if "%HTTP_CODE%"=="200" (
    echo  [OK] Number %Number% sent successfully!
) else (
    echo  [ERROR] HTTP Status: %HTTP_CODE%
    type "%TEMP%\dc_out.txt"
)

echo.
echo  Press [N] for next Number or [Q] to quit...

:WAIT
choice /c NQ /n /m ""
if errorlevel 2 goto END
if errorlevel 1 (
    set /a Number+=1
    goto LOOP
)

:END
echo.
echo  Goodbye!
timeout /t 2 /nobreak >nul
endlocal
exit /b 0
