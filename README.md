[![Gem](https://img.shields.io/gem/v/danger-eslint.svg)](https://rubygems.org/gems/danger-eslint)
[![Gem](https://img.shields.io/gem/dt/danger-eslint.svg)](https://rubygems.org/gems/danger-eslint)
[![Gem](https://img.shields.io/gem/dtv/danger-eslint.svg)](https://rubygems.org/gems/danger-eslint)
[![Travis branch](https://img.shields.io/travis/leonhartX/danger-eslint/master.svg)](https://travis-ci.org/leonhartX/danger-eslint)
# danger-eslint

A [Danger](https://github.com/danger/danger) plugin for [eslint](http://eslint.org/).

## Installation

    $ gem install danger-eslint
    
`eslint` also needs to be installed(global or local) before you run Danger, Please check the [installation guide](http://eslint.org/docs/user-guide/getting-started)
`danger-eslint` will first try local `node_module/.bin/eslint` then the global `eslint`.

## Usage
Run lint without and configuration will do the samething as run `eslint .`  
All lint result will send as individual comment. If your are using Github, the comment will show as a inline comment directly on the violation's position if possiable.

    eslint.lint

Also, you can pass a config file or eslintignore file to danger-eslint with:

    eslint.config_file = /path/yourconfig
    esling.ignore_file = /path/yourigonre
    eslint.lint
    
If you want to lint only new/modified files. You can achieve that with setting the `filtering` parameter to `true`.

    eslint.filtering = true
    eslint.lint

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.

## Upload to Roverdotcom Gemfury account
	
In order to install a new version of danger-eslint, you need to update the version in the [gem_version.rb](lib/eslint/gem_version.rb)
	
1. Build a gem from the gemspec. This will output a gem file `danger-eslint-0.1.1.<rover_build_number>.gem`.

`gem build danger-eslint.gemspec`

2. Use curl to push the new package to our Gemfury account

`curl -F package=@danger-eslint-0.1.1.<rover_build_number>.gem https://<token_from_repo_url>@push.fury.io/roverdotcom/`
