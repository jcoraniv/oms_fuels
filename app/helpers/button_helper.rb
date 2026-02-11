module ButtonHelper
  def action_button(action, path, options = {})
    config = button_config(action)
    options[:class] = "btn btn-sm #{config[:class]} #{options[:class]}".strip
    options[:title] = config[:title]
    options[:data] ||= {}
    options[:data][:bs_toggle] = 'tooltip'
    
    content = content_tag(:i, '', class: config[:icon])
    
    if options[:method] || options[:turbo_method]
      button_to path, options.merge(form: { style: 'display: inline-block;' }) do
        content
      end
    else
      link_to content, path, options
    end
  end

  private

  def button_config(action)
    configs = {
      show: { icon: 'fas fa-eye', class: 'btn-info', title: t('common.show') },
      edit: { icon: 'fas fa-edit', class: 'btn-warning', title: t('common.edit') },
      delete: { icon: 'fas fa-trash', class: 'btn-danger', title: t('common.delete') },
      new: { icon: 'fas fa-plus', class: 'btn-primary', title: t('common.new') },
      approve: { icon: 'fas fa-check', class: 'btn-success', title: 'Approve' },
      cancel: { icon: 'fas fa-times', class: 'btn-danger', title: 'Cancel' },
      complete: { icon: 'fas fa-check-circle', class: 'btn-info', title: 'Complete' },
      print: { icon: 'fas fa-print', class: 'btn-secondary', title: 'Print' }
    }
    configs[action] || { icon: 'fas fa-circle', class: 'btn-secondary', title: action.to_s.titleize }
  end
end
