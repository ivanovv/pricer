module ApplicationHelper

  def current_url(overwrite={})
    url_for :only_path => false, :params => params.merge(overwrite)
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  def search_box
    form_tag(searches_path, :method => 'get') do
      search_field_tag(:q, params[:q], {:class=>"search text"})+
          submit_tag(t(:search), {:name => nil, :class=>"search button"})
    end
  end

  def with_format(format, &block)
    old_formats = formats
    begin
      self.formats = [format]
      return block.call
    ensure
      self.formats = old_formats
    end
  end


end
