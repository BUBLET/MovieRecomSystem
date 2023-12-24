# Этот файл должен быть использован с помощью команды `source bin/activate.fish` *внутри запущенной сессии оболочки fish ( http://fishshell.com ) *.
# Не запускайте его напрямую.

function _bashify_path -d "Преобразует путь в формате fish в формат, который может распознать bash"
    set fishy_path $argv
    set bashy_path $fishy_path[1]
    for path_part in $fishy_path[2..-1]
        set bashy_path "$bashy_path:$path_part"
    end
    echo $bashy_path
end

function _fishify_path -d "Преобразует путь в формате bash в формат, который может распознать fish"
    echo $argv | tr ':' '\n'
end

function deactivate -d 'Выйти из режима виртуальной среды и вернуться к обычной среде.'
    # восстановление старых переменных среды
    if test -n "$_OLD_VIRTUAL_PATH"
        # https://github.com/fish-shell/fish-shell/issues/436 altered PATH handling
        if test (echo $FISH_VERSION | head -c 1) -lt 3
            set -gx PATH (_fishify_path "$_OLD_VIRTUAL_PATH")
        else
            set -gx PATH $_OLD_VIRTUAL_PATH
        end
        set -e _OLD_VIRTUAL_PATH
    end

    if test -n "$_OLD_VIRTUAL_PYTHONHOME"
        set -gx PYTHONHOME "$_OLD_VIRTUAL_PYTHONHOME"
        set -e _OLD_VIRTUAL_PYTHONHOME
    end

    if test -n "$_OLD_FISH_PROMPT_OVERRIDE"
       and functions -q _old_fish_prompt
        # Установка пустого локального `$fish_function_path` для возможности удаления `fish_prompt` с помощью `functions -e`.
        set -l fish_function_path

        # Удаление `fish_prompt` виртуальной среды и восстановление оригинала.
        functions -e fish_prompt
        functions -c _old_fish_prompt fish_prompt
        functions -e _old_fish_prompt
        set -e _OLD_FISH_PROMPT_OVERRIDE
    end

    set -e VIRTUAL_ENV
    set -e VIRTUAL_ENV_PROMPT

    if test "$argv[1]" != 'nondestructive'
        # Самоуничтожение!
        functions -e pydoc
        functions -e deactivate
        functions -e _bashify_path
        functions -e _fishify_path
    end
end

# Отмена нерелевантных переменных.
deactivate nondestructive

set -gx VIRTUAL_ENV 'D:\Мисис\KR_ERIAS\Movie-Recommender-System'

# https://github.com/fish-shell/fish-shell/issues/436 altered PATH handling
if test (echo $FISH_VERSION | head -c 1) -lt 3
   set -gx _OLD_VIRTUAL_PATH (_bashify_path $PATH)
else
    set -gx _OLD_VIRTUAL_PATH $PATH
end
set -gx PATH "$VIRTUAL_ENV"'/Scripts' $PATH

# Переопределение приглашения?
# Если нет, то используйте имя среды.
if test -n ''
    set -gx VIRTUAL_ENV_PROMPT ''
else
    set -gx VIRTUAL_ENV_PROMPT (basename "$VIRTUAL_ENV")
end

# Отмена установленной переменной `$PYTHONHOME`, если она установлена.
if set -q PYTHONHOME
    set -gx _OLD_VIRTUAL_PYTHONHOME $PYTHONHOME
    set -e PYTHONHOME
end

function pydoc
    python -m pydoc $argv
end

if test -z "$VIRTUAL_ENV_DISABLE_PROMPT"
    # Копирование текущей функции `fish_prompt` в `_old_fish_prompt`.
    functions -c fish_prompt _old_fish_prompt

    function fish_prompt
        # Сначала выполняется пользовательское приглашение; оно может зависеть от (pipe)status.
        set -l prompt (_old_fish_prompt)

        printf '(%s) ' $VIRTUAL_ENV_PROMPT

        string join -- \n $prompt # обработка многострочных приглашений
    end

    set -gx _OLD_FISH_PROMPT_OVERRIDE "$VIRTUAL_ENV"
end