module SourcesHelper
  def authors(source)
    out = ''
     source.people.each do |person|
       out <<  link_to(person.full_name,
            person_path(person),
            data: { turbo_frame: "_top" })
        out << " "
      end
      out.html_safe
  end
end
