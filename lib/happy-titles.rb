require File.join(File.dirname(__FILE__), *%w[happy-titles railtie]) if defined?(::Rails::Railtie)

module HappyTitles
  
  attr_accessor :page_title
  
  @@happy_title_settings = {
    :site => 'My Site',
    :tagline => 'My short, descriptive and witty tagline',
    :templates => {
      :default => [':site | :title', ':title | :site']
    }
  }
  
  def happy_title(template_key = :default)
    content_tag(:title, render_title_template(template_key))
  end
  
  def title(page_title = nil)
    if page_title
      @page_title = h(page_title.gsub(/<\/?[^>]*>/, '')) if page_title
    else
      @page_title || ''
    end
  end
  
  def self.included(base)
    base.class_eval do
      
      cattr_accessor :happy_title_settings

      def self.happy_title_template(template_key, format, additional_format = nil)
        template = [format]
        template << additional_format if additional_format
        @@happy_title_settings[:templates][template_key] = template
      end

      def self.happy_title_setting(key, value)
        @@happy_title_settings[key] = value
      end
      
    end
  end
  
  private
    
    def render_title_template(template_key)
      key = (@page_title && @@happy_title_settings[:templates][template_key][1]) ? 1 : 0
      substitute_placeholders(@@happy_title_settings[:templates][template_key][key])
    end
    
    def substitute_placeholders(template)
      title = template
      title = title.gsub(':title', title_text)
      title = title.gsub(':site', @@happy_title_settings[:site])
      title = title.gsub(':tagline', @@happy_title_settings[:tagline])
    end
    
    def title_text
      (@page_title) ? @page_title : @@happy_title_settings[:tagline]
    end
    
end