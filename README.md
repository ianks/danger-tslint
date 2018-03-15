# danger-tslint

A [Danger](https://github.com/danger/danger) plugin for [TSLint](https://palantir.github.io/tslint/).

## Installation

    $ gem install specific_install
    $ gem specific_install -l 'git@github.com:seriwb/danger-tslint.git'
    
`tslint` also needs to be installed(global or local) before you run Danger, Please check the [installation guide](https://palantir.github.io/tslint/usage/cli/)
`danger-tslint` will first try local `node_module/.bin/tslint` then the global `tslint`.

## Usage
Run lint without and configuration will do the something as run `tslint 'src/**/*.{ts,tsx}'`  
All lint result will send as individual comment. If your are using Github, the comment will show as a inline comment directly on the violation's position if possible.

    tslint.lint

Also, you can pass a config file or tslintignore file to danger-tslint with:

    tslint.config_file = '/path/yourconfig'
    tsling.ignore_file = '/path/yourigonre'
    tslint.lint
    
If you want to lint only new/modified files. You can achieve that with setting the `filtering` parameter to `true`.

    tslint.filtering = true
    tslint.lint

And you can change TSLint execution path and target file format.

    tslint.executable_path = './node_modules/.bin/tslint'
    tslint.file_regex = /.tsx?$/
    tslint.lint

It is also possible to specify the project directory and the target files.

    tslint.project_directory = '.'
    tslint.target_files = 'src/**/*.{ts,tsx}'
    tslint.lint
