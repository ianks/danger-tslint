require 'mkmf'
require 'json'

module Danger
  # Lint TypeScript files using [tslint](https://palantir.github.io/tslint/).
  # Results are send as inline comment.
  #
  # @example Run tslint with changed files only
  #
  #          tslint.filtering = true
  #          tslint.lint
  #
  # @tags lint, typescript
  class DangerTslint < Plugin
    # A path to tslint's config file
    # @return [String]
    attr_accessor :config_file

    # A path to tslint's ignore file
    # @return [String]
    attr_accessor :ignore_file

    # A path to tslint's executable
    # @return [String]
    attr_accessor :executable_path

    # File matching regex
    # @return [Regex]
    attr_accessor :file_regex

    # Enable filtering
    # Only show messages within changed files.
    # @return [Boolean]
    attr_accessor :filtering

    # TSLint target files
    # @return [String]
    attr_accessor :target_files

    # A path to tslint target project
    # @return [String]
    attr_accessor :project_directory

    # Lints TypeScript files.
    # Generates `errors` and `warnings` due to tslint's config.
    # Will try to send inline comment if supported(Github)
    #
    # @return  [void]
    #
    def lint
      lint_results
        .reject { |r| r.nil? || r.length.zero? }
        .map { |r| send_comment r }
    end

    private

    # Get tslint' bin path
    #
    # return [String]
    def tslint_path
      local = executable_path ? executable_path : './node_modules/.bin/tslint'
      File.exist?(local) ? local : find_executable('tslint')
    end

    # Get tslint' file pattern regex
    #
    # return [String]
    def matching_file_regex
      file_regex ? file_regex : /.*\.tsx?$/
    end

    # Get TypeScript project path
    #
    # return [String]
    def project_path
      project_directory ? project_directory : '.'
    end

    # Get lint result regards the filtering option
    #
    # return [Hash]
    def lint_results
      bin = tslint_path
      raise 'tslint is not installed' unless bin
      return run_lint(bin, target_files) unless filtering
      ((git.modified_files - git.deleted_files) + git.added_files)
        .select { |f| f[matching_file_regex] }
        .map { |f| f.gsub("#{Dir.pwd}/", '') }
        .map { |f| run_lint(bin, f).first }
    end

    # Run tslint against a single file.
    #
    # @param   [String] bin
    #          The binary path of tslint
    #
    # @param   [String] file
    #          File to be linted
    #
    # return [Hash]
    def run_lint(bin, file)
      command = "#{bin} --format json"
      command << " -c #{config_file}" if config_file
      command << " -e #{ignore_file}" if ignore_file
      command << " -p #{project_path}"
      command << " '#{file}'" if file
      result = `#{command}`
      result = '[]' if result.include? 'is not included in project'
      JSON.parse(result)
    end

    # Send comment with danger's warn or fail method.
    #
    # @return [void]
    def send_comment(results)
      dir = "#{Dir.pwd}/"
      filename = results['name'].gsub(dir, '')
      method = results['ruleSeverity'] == 'ERROR' ? 'fail' : 'warn'
      line = results['endPosition']['line'] + 1
      send(method, results['failure'], file: filename, line: line)
    end
  end
end
