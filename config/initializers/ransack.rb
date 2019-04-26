Ransack.configure do |c|
  c.custom_arrows = {
    up_arrow: '<i class="fa fa-sort-up"></i>',
    down_arrow: '<i class="fa fa-sort-down"></i>'
  }
end

# Override the link name to omit the &nbsp;
# https://github.com/activerecord-hackery/ransack/blob/master/lib/ransack/helpers/form_helper.rb#L127
module Ransack
  module Helpers
    module FormHelper
      class SortLink
        def name
          [ERB::Util.h(@label_text), order_indicator].compact.join.html_safe
        end
      end
    end
  end
end
