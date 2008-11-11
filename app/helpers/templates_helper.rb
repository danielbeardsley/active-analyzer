module TemplatesHelper
  def path_column(record)
    %|<a href='#' onclick='GetTemplateData("#{record.path}");return false;'>#{record.path}</a>|
  end
end
