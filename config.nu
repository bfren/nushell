$env.config.show_banner = false
$env.config.datetime_format.normal = "%a, %d %b %Y %H:%M:%S %z"

let table_format = "%Y-%m-%d %H:%M:%S"
$env.config.datetime_format.table = $table_format

$env.PROMPT_COMMAND_RIGHT = {||
    let time_segment = ansi reset
        | append (ansi magenta) 
        | append (date now | format date $table_format)
        | str join
        | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)"
        | str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}"

    let last_exit_code = match $env.LAST_EXIT_CODE {
        0 => "",
        _ => ([(ansi rb) $env.LAST_EXIT_CODE] | str join)
    }

    [$last_exit_code (char space) $time_segment] | str join
}

