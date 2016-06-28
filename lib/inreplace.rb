module Inreplace
  Settings = Struct.new(
    :file,
    :input,
    :tag
  )

  class Interpolation
    def initialize(tag:)
      @tag = tag
    end

    def interpolate(input, replaced)
      input.gsub(/(#{start_placeholder}).*?(#{end_placeholder})/m) {|m|
        [
          $1,
          replaced,
          $2
        ].map(&:strip).join($/)
      }
    end

    private def start_placeholder
      "<!-- #{@tag} -->"
    end

    private def end_placeholder
      "<!-- /#{@tag} -->"
    end
  end

  class Injector
    def initialize(tag: , dest_file:)
      @tag = tag
      @dest_file = dest_file
    end

    def inject(input_io)
      interpolation = Inreplace::Interpolation.new(tag: @tag)
      content = interpolation.interpolate(@dest_file.read, input_io.read)
      @dest_file.write(content)
    end
  end
end
