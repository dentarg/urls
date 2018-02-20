require "metainspector"
require "twingly/url"

module Urls
  module_function

  def by_url(url)
    uri = parse(url, normalize: false).to_s

    return [] if uri.empty?

    options = {
      warn_level: :store,
      download_images: false,
      html_content_only: true,
    }

    page = MetaInspector.new(uri, options)
    page.links.external
  end

  def by_text(text, normalize: false)
    urls_and_crap = URI.extract(text)
    urls_and_crap
      .map { |url| parse(url, normalize: normalize) }
      .select { |url| url.valid? }
      .map(&:to_s)
      .uniq
  end

  def parse(url, normalize:)
    parsed_url = Twingly::URL.parse(url)

    normalize ? parsed_url.normalized : parsed_url
  end
end
