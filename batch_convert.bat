@echo off
rem ffmpeg batch bideo converter 1.0.0

set ffmpeg=ffmpeg.exe
rem loglevel: quiet, panic, fatal, error, warning, info, verbose, debug
set ffmpeg_loglevel=info
set dest_dir=converted
set source_extension=mkv
set video_codec=copy
set crf=28
set preset=medium
set audio_codec=copy
set audio_bitrate=128k
set video_params=
set audio_params=

if not exist %ffmpeg% goto FFMPEG_MISSING

cls

rem Script header
echo .
echo ffmpeg batch video converter 1.0.0

rem Soure file extension seletion menu
echo .
echo Select the source file extension:
echo 1 - AVI
echo 2 - MKV (default)
echo 3 - MP4
echo 4 - Exit
set /P ui1=Make a selection then press ENTER:
if "%ui1%"=="" set source_extension=mkv
if "%ui1%"=="1" set source_extension=avi
if "%ui1%"=="2" set source_extension=mkv
if "%ui1%"=="3" set source_extension=mp4
if "%ui1%"=="4" goto END

rem Video encoder selection menu
echo .
echo Select the video codec:
echo 1 - Copy (default)
echo 2 - x265
echo 3 - Exit
set /P ui2=Make a selection then press ENTER:
if "%ui2%"=="" set video_codec=copy
if "%ui2%"=="1" set video_codec=copy
if "%ui2%"=="2" set video_codec=libx265
if "%ui2%"=="3" goto END

rem If no video encoding, skip video configuration
if not "%video_codec%"=="copy" goto VIDEO_CONFIG
if "%video_codec%"=="copy" goto AUDIO_CONFIG

:VIDEO_CONFIG
rem Constant Rate Factor selection menu
echo .
echo Enter the Constant Rate Factor (CRF) (0-51):
echo Default: 28
echo Type EXIT to exit.
set /P ui3=Enter a value then press ENTER:
set crf=%ui3%
if "%ui3%"=="" set crf=28
if /I "%ui3%"=="EXIT" GOTO END

rem Preset selection menu
echo .
echo Select the compression efficiency preset:
echo 1 - ultrafast
echo 2 - superfast
echo 3 - veryfast
echo 4 - faster
echo 5 - fast
echo 6 - medium
echo 7 - slow (default)
echo 8 - slower
echo 9 - veryslow
echo 10 - placebo
echo 11 - Exit
set /P ui4=Make a selection then press ENTER:
if "%ui4%"=="" set preset=slow
if "%ui4%"=="1" set preset=ultrafast
if "%ui4%"=="2" set preset=superfast
if "%ui4%"=="3" set preset=veryfast
if "%ui4%"=="4" set preset=faster
if "%ui4%"=="5" set preset=fast
if "%ui4%"=="6" set preset=medium
if "%ui4%"=="7" set preset=slow
if "%ui4%"=="8" set preset=slower
if "%ui4%"=="9" set preset=veryslow
if "%ui4%"=="10" set preset=placebo
if "%ui4%"=="11" goto END

goto AUDIO_CONFIG

:AUDIO_CONFIG
rem Audio encoder selection menu
echo .
echo Select the audio codec:
echo 1 - Copy
echo 2 - AAC (default)
echo 4 - Exit
set /P ui5=Make a selection then press ENTER:
if "%ui5%"=="" set audio_codec=aac
if "%ui5%"=="1" set audio_codec=copy
if "%ui5%"=="2" set audio_codec=aac
if "%ui5%"=="4" goto END

rem If no audio encoding, skip audio configuration
if "%audio_codec%"=="copy" goto CONVERT

rem Audio bitrate selection menu
echo .
echo Select the audio bitrate:
echo 1 - 128k
echo 2 - 160k
echo 3 - 192k
echo 4 - 224k
echo 5 - 384k
echo 6 - 448k
echo 7 - 640k (default)
echo 8 - Exit
set /P ui6=Make a selection then press ENTER:
if "%ui6%"=="" set audio_bitrate=640k
if "%ui6%"=="1" set audio_bitrate=128k
if "%ui6%"=="2" set audio_bitrate=160k
if "%ui6%"=="3" set audio_bitrate=192k
if "%ui6%"=="4" set audio_bitrate=224k
if "%ui6%"=="5" set audio_bitrate=384k
if "%ui6%"=="6" set audio_bitrate=448k
if "%ui6%"=="7" set audio_bitrate=640k
if "%ui6%"=="8" goto END

goto CONVERT

:CONVERT
echo .
echo Selections:
echo     Source file extension: %source_extension%
echo     Video codec: %video_codec%
if not "%video_codec%"=="copy" (
	echo     CRF: %CRF%
	echo     Preset: %preset%
	)
echo     Audio codec: %audio_codec%
if not "%audio_codec%"=="copy" (
	echo     Audio bitrate: %audio_bitrate%
	)
echo .
pause

if not "%video_codec%"=="copy" set video_params=-vtag hvc1 -pix_fmt yuv420p10le -x265-params lossless=1:profile=main10 -crf %crf% -preset %preset% 

if not "%audio_codec%"=="copy" set audio_params=-b:a %audio_bitrate% 

rem Create the dest_dir if it does not exist
if not exist %dest_dir% md %dest_dir%

rem Convert videos
for %%f in (*.%source_extension%) do (
	echo.
	echo Converting '%%f' to '%dest_dir%\%%~nf.mp4'
	%ffmpeg% -hide_banner -loglevel %ffmpeg_loglevel% -i "%%f" -c:v %video_codec% %video_params%-c:a %audio_codec% %audio_params%"%dest_dir%\%%~nf.mp4"
)
goto END

:FFMPEG_MISSING
echo ffmpeg.exe not found. Modify this script with the correct location to ffmpeg.exe.
echo Current ffmpeg location: %ffmpeg%
goto END

:END
pause
