@echo off
setlocal enableextensions
title Reset AnyDesk - by TR1P3ZIM [MORTE LENTA Team]

:: --- CABEÇALHO PERSONALIZADO ---
cls
color 0A
echo.
echo ========================================================
echo               MORTE LENTA TEAM
echo ========================================================
echo    Script de Reset ID AnyDesk - Uso Educacional
echo ========================================================
echo           Ferramenta desenvolvida por:
echo                   TR1P3ZIM
echo ========================================================
echo.

:: --- 1. VERIFICAÇÃO DE ADMINISTRADOR ---
fsutil dirty query %systemdrive% >nul
if %errorlevel% neq 0 (
    echo [ERRO] PRECISAR RODAR COMO ADMIN.
    echo.
    echo Clique com o botao direito e escolha: "Executar como administrador"
    pause
    exit
)

:: --- 2. FECHAR ANYDESK (FORÇADO) ---
echo [1/5] Parando processos...
net stop AnyDeskService >nul 2>&1
net stop AnyDesk >nul 2>&1
taskkill /f /im AnyDesk.exe >nul 2>&1

:: --- 3. BACKUP DOS DADOS (FAVORITOS) ---
echo [2/5] Salvando favoritos...
if exist "%APPDATA%\AnyDesk\user.conf" (
    copy /y "%APPDATA%\AnyDesk\user.conf" "%temp%\user.conf" >nul
)
if exist "%APPDATA%\AnyDesk\thumbnails" (
    rmdir /s /q "%temp%\thumbnails" >nul 2>&1
    xcopy /c /e /h /r /y /i /k "%APPDATA%\AnyDesk\thumbnails" "%temp%\thumbnails" >nul 2>&1
)

:: --- 4. DELETAR ARQUIVOS DE ID (RESET) ---
echo [3/5] Limpando rastros e ID antigo...
del /f /q "%ProgramData%\AnyDesk\service.conf" >nul 2>&1
del /f /q "%ProgramData%\AnyDesk\system.conf" >nul 2>&1
del /f /q "%ProgramData%\AnyDesk\*.trace" >nul 2>&1
del /f /q "%APPDATA%\AnyDesk\service.conf" >nul 2>&1
del /f /q "%APPDATA%\AnyDesk\system.conf" >nul 2>&1
del /f /q "%APPDATA%\AnyDesk\*.trace" >nul 2>&1

:: --- 5. GERAR NOVO ID ---
echo [4/5] Gerando novo ID...
net start AnyDesk >nul 2>&1
set "AnyDeskPath86=%ProgramFiles(x86)%\AnyDesk\AnyDesk.exe"
set "AnyDeskPath64=%ProgramFiles%\AnyDesk\AnyDesk.exe"

if exist "%AnyDeskPath86%" ( start "" "%AnyDeskPath86%" ) else (
    if exist "%AnyDeskPath64%" ( start "" "%AnyDeskPath64%" )
)

echo Aguardando sistema...
:aguardar_id
timeout /t 2 /nobreak >nul
if exist "%ProgramData%\AnyDesk\system.conf" goto restaurar
if exist "%APPDATA%\AnyDesk\system.conf" goto restaurar
set /a contador+=1
if %contador% geq 10 goto restaurar
goto aguardar_id

:restaurar
:: --- 6. RESTAURAR FAVORITOS ---
echo [5/5] Restaurando configuracoes...
taskkill /f /im AnyDesk.exe >nul 2>&1
net stop AnyDesk >nul 2>&1
timeout /t 1 /nobreak >nul

if exist "%temp%\user.conf" copy /y "%temp%\user.conf" "%APPDATA%\AnyDesk\user.conf" >nul
if exist "%temp%\thumbnails" xcopy /c /e /h /r /y /i /k "%temp%\thumbnails" "%APPDATA%\AnyDesk\thumbnails" >nul 2>&1

:: --- FINALIZAÇÃO ---
cls
echo.
echo ========================================================
echo        PROCESSO CONCLUIDO COM SUCESSO!
echo ========================================================
echo.
echo      Team: MORTE LENTA
echo      Dev:  TR1P3ZIM
echo.
echo Pode abrir o AnyDesk. O aviso deve ter sumido.
timeout /t 10
