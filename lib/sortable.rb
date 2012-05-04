module Sortable

  # To change this template use File | Settings | File Templates.
  def get_sort_settings_from_params
  sort = case params['sort']
           when "name" then "original_description"
           when "recent" then "created_at desc"
         end

  sort ||= "created_at desc"
  end

end
