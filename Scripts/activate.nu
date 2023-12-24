# Модуль активации virtualenv
# Активация с помощью `overlay use activate.nu`
# Деактивация с помощью `deactivate`, как обычно
#
# Для настройки имени оверлея вы можете использовать `overlay use activate.nu as foo`,
# но тогда просто `deactivate` не будет работать, потому что это всего лишь псевдоним,
# скрывающий оверлей "activate". Вам придется вручную вызывать `overlay hide foo`.

export-env {
    def is-string [x] {
        ($x | describe) == 'string'
    }

    def has-env [...names] {
        $names | each {|n|
            $n in $env
        } | all {|i| $i == true}
    }

    # Эмуляция `test -z`, но лучше, так как обрабатывает, например, 'false'
    def is-env-true [name: string] {
        if (has-env $name) {
            # Попытка преобразовать 'true', '0', '1', и сбой, если невозможно конвертировать
            let parsed = (do -i { $env | get $name | into bool })
            if ($parsed | describe) == 'bool' {
                $parsed
            } else {
                not ($env | get -i $name | is-empty)
            }
        } else {
            false
        }
    }

    let virtual_env = 'D:\Мисис\KR_ERIAS\Movie-Recommender-System'
    let bin = 'Scripts'

    let is_windows = ($nu.os-info.family) == 'windows'
    let path_name = (if (has-env 'Path') {
            'Path'
        } else {
            'PATH'
        }
    )

    let venv_path = ([$virtual_env $bin] | path join)
    let new_path = ($env | get $path_name | prepend $venv_path)

    # Если нет стандартного приглашения, то используйте имя среды
    let virtual_env_prompt = (if ('' | is-empty) {
        ($virtual_env | path basename)
    } else {
        ''
    })

    let new_env = {
        $path_name         : $new_path
        VIRTUAL_ENV        : $virtual_env
        VIRTUAL_ENV_PROMPT : $virtual_env_prompt
    }

    let new_env = (if (is-env-true 'VIRTUAL_ENV_DISABLE_PROMPT') {
        $new_env
    } else {
        # Создание нового приглашения для сессии
        let virtual_prefix = $'(char lparen)($virtual_env_prompt)(char rparen) '

        # Резервное копирование старого построителя приглашения
        let old_prompt_command = (if (has-env 'PROMPT_COMMAND') {
                $env.PROMPT_COMMAND
            } else {
                ''
        })

        let new_prompt = (if (has-env 'PROMPT_COMMAND') {
            if 'closure' in ($old_prompt_command | describe) {
                {|| $'($virtual_prefix)(do $old_prompt_command)' }
            } else {
                {|| $'($virtual_prefix)($old_prompt_command)' }
            }
        } else {
            {|| $'($virtual_prefix)' }
        })

        $new_env | merge {
            PROMPT_COMMAND      : $new_prompt
            VIRTUAL_PREFIX      : $virtual_prefix
        }
    })

    # Переменные среды, которые будут загружены виртуальной средой
    load-env $new_env
}

export alias pydoc = python -m pydoc
export alias deactivate = overlay hide activate