# config/initializers/currency.rb
# Set default currency format to (Bs)
module ActionView
  module Helpers
    module NumberHelper
      alias_method :original_number_to_currency, :number_to_currency
      
      def number_to_currency(number, options = {})
        options[:unit] ||= 'Bs'
        options[:separator] ||= '.'
        options[:delimiter] ||= ','
        options[:format] ||= '%u %n'
        original_number_to_currency(number, options)
      end
    end
  end
end
