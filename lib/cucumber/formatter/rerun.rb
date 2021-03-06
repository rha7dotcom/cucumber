module Cucumber
  module Formatter
    # The formatter used for <tt>--format rerun</tt>
    #
    # This formatter keeps track of all failing features and print out their location.
    # Example:
    #
    #   features/foo.feature:34 features/bar.feature:11:76:81
    #
    # This formatter is used by AutoTest - it will use the output to decide what
    # to run the next time, simply passing the output string on the command line.
    #
    class Rerun
      def initialize(step_mother, io, options)
        @io = io
        @options = options
        @file_names = []
        @file_colon_lines = Hash.new{|h,k| h[k] = []}
      end

      def features(features)
        super
        files = @file_names.uniq.map do |file|
          lines = @file_colon_lines[file]
          "#{file}:#{lines.join(':')}"
        end
        @io.puts files.join(' ')
      end

      def feature_element(feature_element)
        @rerun = false
        super
        if @rerun
          file, line = *feature_element.file_colon_line.split(':')
          @file_colon_lines[file] << line
          @file_names << file
        end
      end

      def step_name(keyword, step_match, status, source_indent, background)
        @rerun = true if [:failed].index(status)
      end
    end
  end
end
