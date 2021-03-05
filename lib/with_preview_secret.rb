module WithPreviewSecret
  def preview_secret
    Digest::MD5.hexdigest(url).slice(0..7)
  end

  def preview_secret_url site = nil
    url + "?preview_secret=#{preview_secret}"
  end
end