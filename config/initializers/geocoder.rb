if Rails.env.test?
  module Geocoder
    module Lookup
      class Test < Base
        def self.add_random_stub(results)
          stubs['random'] = results
        end

        def self.read_stub(query_text)
          stubs.fetch('random')
        end
      end
    end
  end

  Geocoder.configure(:lookup => :test)
else
  Geocoder.configure(
    lookup: :yandex,
    timeout: 5,
    units: :km,
    language: :ru,
    api_key: 'ff25fff4-dfc6-4e02-981e-873f6caa759f',
    use_https: true
  )
end
