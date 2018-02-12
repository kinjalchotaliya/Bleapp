module Paperclip
  class AudioBitRateProcessor < Processor
    def initialize( file, options = {}, attachment = nil )
      super
      @file = file
      @basename = File.basename @file.path
      @format = options[ :format ] || 'mp3'
      @bit_rate = options[ :bit_rate ] || '64k'
    end

    def make
      source = @file
      output = Tempfile.new [ @basename, ".#{ @format }" ]

      begin
        parameters = '-y -i :source -b:a :bit_rate :dest'
        Paperclip.run( 'ffmpeg', parameters, :source => File.expand_path( source.path ),
                                             :dest => File.expand_path( output.path ),
                                             :bit_rate => @bit_rate )
      rescue
        raise Paperclip::Error.new "There was an error changing '#{ @basename }' bitrate to #{ @bit_rate }"
      end

      output
    end
  end
end
