module ApplicationHelper
  def flash_alerts
    return unless flash.any?

    flash.map do |type, message|
      alert_class = case type.to_sym
      when :notice, :success then 'success'
      when :alert, :error then 'danger'
      when :warning then 'warning'
      when :info then 'info'
      else 'info'
      end

      icon_class = case alert_class
      when 'success' then 'fas fa-check'
      when 'danger' then 'fas fa-ban'
      when 'warning' then 'fas fa-exclamation-triangle'
      when 'info' then 'fas fa-info'
      end

      alert_title = t("common.alert_titles.#{alert_class}")

      content_tag(:div, class: "alert alert-#{alert_class} alert-dismissible", data: { 'auto-dismiss': '5000' }) do
        concat content_tag(:button, '', type: 'button', class: 'btn-close', 'data-bs-dismiss': 'alert', 'aria-label': 'Close')
        concat content_tag(:h5, (content_tag(:i, '', class: "icon #{icon_class}") + " #{alert_title}").html_safe, class: 'mb-2')
        if message.is_a?(Array)
          ul_content = message.map { |msg| content_tag(:li, msg) }.join.html_safe
          concat content_tag(:ul, ul_content, class: 'mb-0')
        else
          concat message
        end
      end
    end.join.html_safe
  end

  def model_errors_alert(model)
    return unless model.errors.any?

    model_name = model.class.model_name.human.downcase
    error_count = t('common.error_count', count: model.errors.count)
    prohibited_msg = t('common.prohibited_from_saving', model: model_name)
    alert_title = t('common.alert_titles.danger')

    content_tag(:div, class: "alert alert-danger alert-dismissible") do
      concat content_tag(:button, '', type: 'button', class: 'btn-close', 'data-bs-dismiss': 'alert', 'aria-label': 'Close')
      concat content_tag(:h5, (content_tag(:i, '', class: "icon fas fa-ban") + " #{alert_title}").html_safe, class: 'mb-2')
      concat "#{error_count} #{prohibited_msg}"
      ul_content = model.errors.full_messages.map { |msg| content_tag(:li, msg) }.join.html_safe
      concat content_tag(:ul, ul_content, class: 'mb-0')
    end
  end
end
