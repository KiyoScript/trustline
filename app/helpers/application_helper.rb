module ApplicationHelper
  include Pagy::Method

  def flash_class(type)
    case type.to_sym
    when :notice, :success then "alert-success"
    when :alert, :error    then "alert-error"
    when :warning          then "alert-warning"
    when :info             then "alert-info"
    else "alert-info"
    end
  end

  def flash_icon(type)
    icon_name = case type.to_sym
    when :notice, :success then "check-circle"
    when :alert, :error    then "x-circle"
    when :warning          then "exclamation-triangle"
    else "information-circle"
    end

    icon(icon_name, library: "heroicons", class: "size-5 shrink-0")
  end
end
