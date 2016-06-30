module Roh
  module Associations
    def belongs_to(model, options)
      define_method(model) do
        model = options[:class_name].constantize
        model.find_by(id: send(options[:foreign_key]))
      end
    end

    def has_many(model, options)
      define_method(model) do
        model = (options[:class_name]).constantize
        model.where("#{options[:foreign_key]} LIKE ?", id)
      end
    end
  end
end
