module ApplicationHelper
  def active_class_if_url(url)
    return 'block py-2 pr-4 pl-3 text-white rounded-lg bg-blue-500' if request.path.include?(url) 
    'block py-2 pr-4 pl-3 hover:text-sky-500 dark:hover:text-sky-400'
  end

  def plant_name(plant)
    "<em>#{plant.name}</em> <small>#{plant.species.authors.join(', ')}</small>".html_safe
  end
end
