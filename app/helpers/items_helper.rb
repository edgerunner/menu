module ItemsHelper
  def small_cents(p)
    raw p.sub(/([.,]\d+\s)/, content_tag(:small, '\1'))
  end
end
