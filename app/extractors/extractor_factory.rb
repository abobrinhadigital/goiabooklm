module Extractors
  class ExtractorFactory
    EXTRACTORS = {
      /xda-developers\.com/ => XdaExtractor,
      /howtogeek\.com/ => HowToGeekExtractor,
      /itsfoss\.com/ => ItsFossExtractor,
      'tecnoblog.net' => TecnoblogExtractor,
      'tudocelular.com' => TudoCelularExtractor,
      'gsmarena.com' => GsmArenaExtractor,
      '9to5linux.com' => NineToFiveLinuxExtractor,
      'diolinux.com.br' => DioLinuxExtractor,
      'omgubuntu.co.uk' => OmgUbuntuExtractor
    }.freeze

    def self.extract(url, html)
      extractor_class = EXTRACTORS.find { |pattern, _| url =~ pattern }&.last || BaseExtractor
      extractor_class.new(url, html).extract
    end
  end
end
