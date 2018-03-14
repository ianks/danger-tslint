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
        .reject { |r| r['messages'].length.zero? }
        .reject { |r| r['messages'].first['message'].include? 'matching ignore pattern' }
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
      file_regex ? file_regex : /.tsx?$/
    end

    # Get lint result regards the filtering option
    #
    # return [Hash]
    def lint_results
      bin = tslint_path
      raise 'tslint is not installed' unless bin
      file = target_files ? target_files : '.'
      return run_lint(bin, file) unless filtering
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
      command = "#{bin}"
      command << " -c #{config_file}" if config_file
      command << " -e #{ignore_file}" if ignore_file
      command << " -p #{project_directory}" if project_directory
      result = `#{command} #{file}`
      JSON.parse(result)
    end

    # Send comment with danger's warn or fail method.
    #
    # @return [void]
    def send_comment(results)
      dir = "#{Dir.pwd}/"
      results['messages'].each do |r|
        filename = results['filePath'].gsub(dir, '')
        method = r['severity'] > 1 ? 'fail' : 'warn'
        send(method, r['message'], file: filename, line: r['line'])
      end
    end
  end
end
