# danger-tslint

A [Danger](https://github.com/danger/danger) plugin for [TSLint](https://palantir.github.io/tslint/).

## Installation

    $ gem install specific_install
    $ gem specific_install -l 'git@github.com:seriwb/danger-tslint.git'
    
`tslint` also needs to be installed(global or local) before you run Danger, Please check the [installation guide](https://palantir.github.io/tslint/usage/cli/)
`danger-tslint` will first try local `node_module/.bin/tslint` then the global `tslint`.

## Usage
Run lint without and configuration will do the something as run `tslint -p .`  
All lint result will send as individual comment. If your are using Github, the comment will show as a inline comment directly on the violation's position if possible.

    tslint.lint

Also, you can pass a config file or tslintignore file to danger-tslint with:

    tslint.config_file = '/path/yourconfig'
    tsling.ignore_file = '/path/yourigonre'
    tslint.lint

And you can change TSLint execution path and target file format.

    tslint.executable_path = './node_modules/.bin/tslint'
    tslint.lint

It is also possible to specify the project directory and the target files.

    tslint.project_directory = 'subproject'
    tslint.executable_path = 'subproject/node_modules/.bin/tslint'
    tslint.lint

If you want to lint only new/modified files. You can achieve that with setting the `filtering` parameter to `true`.

    tslint.filtering = true
    tslint.lint

But, in this case, ou probably have to specify the value of `target_files` and `file_regex` to match "include" in tsconfig.json.

    tslint.filtering = true
    tslint.project_directory = 'subproject'
    tslint.target_files = 'subproject/src/**/*.{ts,tsx}'
    tslint.file_regex = /subproject\/src\/.*\.tsx?$/
    tslint.lint

### Default value

| Parameter         | Default value                |
| :---------------- | :--------------------------- |
| config_file       | nil                          |
| ignore_file       | nil                          |
| executable_path   | './node_modules/.bin/tslint' |
| file_regex        | /.\*.tsx?/                   |
| filtering         | nil                          |
| target_files      | nil                          |
| project_directory | '.'                          |
