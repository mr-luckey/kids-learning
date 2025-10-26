@echo off
echo Fixing Android build issues...

REM Clean Flutter cache
flutter clean

REM Get dependencies
flutter pub get

REM Try to find Java installation
for /f "tokens=*" %%i in ('where java 2^>nul') do (
    echo Found Java at: %%i
    set JAVA_HOME=%%~dpi
    goto :found_java
)

echo Java not found in PATH. Please install Java JDK 11 or higher.
echo You can download it from: https://adoptium.net/
pause
exit /b 1

:found_java
echo Setting JAVA_HOME to: %JAVA_HOME%

REM Try to build
echo Building APK...
flutter build apk --debug

echo Build completed!
pause
