require 'cgi'
require 'will_paginate/core_ext'
require 'will_paginate/view_helpers'
require 'will_paginate/view_helpers/link_renderer_base'
require 'will_paginate/view_helpers/link_renderer'

module WillPaginate
  module ViewHelpers
    class AjaxLinkRenderer < LinkRenderer
      def prepare(collection, options, template)
        options[:params] ||= {}
        options[:params]["_"] = nil
        super(collection, options, template)
      end

      protected
      def link(text, target, attributes = {})
        if target.is_a? Fixnum
          attributes[:rel] = rel_value(target)
          target = url(target)
        end
        ajax_call = "$.ajax({url: '#{target}', dataType: 'script'});"
        @template.link_to_function(text.to_s.html_safe, ajax_call, attributes)
      end
    end

    def ajax_will_paginate(collection, options = {})
      will_paginate(collection, options.merge(:renderer => WillPaginate::ViewHelpers::AjaxLinkRenderer))
    end
  end
end
