# coding: utf-8
module ApplicationHelper
  def flash_paragraphs
    output = ""
    [:notice, :alert].each do |f|
      if flash[f] then
        output << content_tag(:p, :class => f.to_s) do
          flash[f]
        end
      end
    end
    raw output
  end
end
