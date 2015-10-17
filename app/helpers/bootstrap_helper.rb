module BootstrapHelper
  def bs_progress(percentage, options={})
    pb_class = case percentage
                 when 0..30 then 'progress-bar-danger'
                 when 30..70 then 'progress-bar-warning'
                 else 'progress-bar-success'
               end
    content_tag(:div, class: 'progress') do
      content_tag(:div, class: "progress-bar #{pb_class}", role: 'progressbar', aria: { valuenow: percentage }, style: "width: #{percentage}%;") do
      end
    end
  end

  def bs_panel(options={}, &block)
    css_cls = options[:class]
    context_class = "panel-#{options[:context].try(:to_s) || 'default'}"

    content_tag(:div, class: "panel #{context_class} #{css_cls}") do
      capture(BHPanel.new(self), &block)
    end
  end

  class BHPanel
    attr_accessor :helper
    alias_method :h, :helper

    def initialize(helper)
      @helper = helper
    end

    def header(options={}, &block)
      title = options[:title]
      heading = options[:heading]

      if title
        h.content_tag(:div, class: 'panel-heading') do
          h.content_tag(:h3, title, class: 'panel-title')
        end
      elsif heading
        h.content_tag(:div, heading, class: 'panel-heading')
      else
        h.content_tag(:div, class: 'panel-heading', &block)
      end
    end

    def body(&block)
      h.content_tag(:div, class: 'panel-body', &block)
    end

    def footer(&block)
      h.content_tag(:div, class: 'panel-footer', &block)
    end
  end
end