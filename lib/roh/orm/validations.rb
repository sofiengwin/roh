module Roh
  class Validations
    attr_accessor :errors

    def initialize to_validate, record
      @to_validate = to_validate
      @record = record
      @errors = {}
    end

    def validation_errors
      get_attributes.each do |attribute|
        if @to_validate.keys.include? attribute
          value = @record.send(attribute)
          check_valid(attribute, value)
        end
      end
    end

    def get_attributes
      @record.instance_variables.map do |attribute|
        attribute.to_s.gsub("@", "").to_sym
      end
    end

    def check_valid(attribute, value)
      set_callback_action(attribute) if validate?(value)
    end

    def validate?(value)
      value.nil? || value.empty?
    end

    def set_callback_action(attribute)
      errors[attribute] = "#{attribute.to_s.capitalize} can't be blank"
    end

    def record_errors
      validation_errors
      errors
    end
  end
end
