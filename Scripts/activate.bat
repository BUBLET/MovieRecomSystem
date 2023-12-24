@set "VIRTUAL_ENV=D:\Мисис\KR_ERIAS\Movie-Recommender-System"

@set "VIRTUAL_ENV_PROMPT="
@if NOT DEFINED VIRTUAL_ENV_PROMPT (
    @for %%d in ("%VIRTUAL_ENV%") do @set "VIRTUAL_ENV_PROMPT=%%~nxd"
)

@if defined _OLD_VIRTUAL_PROMPT (
    @set "PROMPT=%_OLD_VIRTUAL_PROMPT%"  # Восстанавливаем предыдущее значение PROMPT, если оно было сохранено
) else (
    @if not defined PROMPT (
        @set "PROMPT=$P$G"  # Устанавливаем базовое значение PROMPT, если оно не было определено ранее
    )
    @if not defined VIRTUAL_ENV_DISABLE_PROMPT (
        @set "_OLD_VIRTUAL_PROMPT=%PROMPT%"  # Сохраняем текущее значение PROMPT
    )
)
@if not defined VIRTUAL_ENV_DISABLE_PROMPT (
    @set "PROMPT=(%VIRTUAL_ENV_PROMPT%) %PROMPT%"  # Добавляем префикс с названием виртуальной среды к PROMPT
)

@REM Не используйте () для избежания проблем с ними в %PATH%
@if defined _OLD_VIRTUAL_PYTHONHOME @goto ENDIFVHOME
    @set "_OLD_VIRTUAL_PYTHONHOME=%PYTHONHOME%"  # Сохраняем предыдущее значение PYTHONHOME
:ENDIFVHOME

@set PYTHONHOME=

@REM if defined _OLD_VIRTUAL_PATH (
@if not defined _OLD_VIRTUAL_PATH @goto ENDIFVPATH1
    @set "PATH=%_OLD_VIRTUAL_PATH%"  # Восстанавливаем предыдущее значение PATH
:ENDIFVPATH1
@REM ) else (
@if defined _OLD_VIRTUAL_PATH @goto ENDIFVPATH2
    @set "_OLD_VIRTUAL_PATH=%PATH%"  # Сохраняем текущее значение PATH
:ENDIFVPATH2

@set "PATH=%VIRTUAL_ENV%\Scripts;%PATH%"  # Добавляем путь к исполняемым файлам виртуальной среды в PATH