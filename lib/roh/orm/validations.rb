module Roh
  module Validations
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def validates(attribute, options)
        @validators ||= []
        @validators << [attribute, options]
      end

      def to_validate
        @validators
      end
    end

    def validate
      validators = self.class.to_validate
      return unless validators
      validators.each do |validator|
        attribute, options = validator
        send("validate_#{options.keys[0]}", attribute, options)
      end
    end

    def validate_presence(attribute, options)
      if send(attribute).nil? || send(attribute).empty?
        add_error(attribute, "#{attribute.capitalize} can't be blank")
      end
    end

    def validate_format(attribute, options)
      if send(attribute) !~ options[:format][:with]
        add_error(
          attribute,
          "#{attribute.capitalize} didn't match pattern"
        )
      end
    end

    def validate_length(attribute, options)
      if validate_max_length?(attribute, options)
        add_error(attribute, "#{attribute.capitalize} is too long")
      elsif validate_min_length?(attribute, options)
        add_error(attribute, "#{attribute.capitalize} is too short")
      end
    end

    def validate_uniqueness(attribute, options)
      if send(attribute) && find_uniqueness(attribute)
        add_error(attribute, "#{attribute.capitalize} already exist")
      end
    end

    def validate_max_length?(attribute, options)
      send(attribute) && options[:length][:max] &&
        send(attribute).length > options[:length][:max]
    end

    def validate_min_length?(attribute, options)
      send(attribute) && options[:length][:min] &&
        send(attribute).length < options[:length][:min]
    end

    def find_uniqueness(attribute)
      self.class.find_by(attribute => send(attribute))
    end

    def add_error(attribute, error_message)
      errors[attribute] ||= []
      errors[attribute] << error_message
    end
  end
end
