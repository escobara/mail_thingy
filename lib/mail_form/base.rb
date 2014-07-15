module MailForm
	class Base
		class_attribute :attribute_names
		self.attribute_names = []
		include ActiveModel::Conversion
		extend ActiveModel::Naming
		extend ActiveModel::Translation
		include ActiveModel::AttributeMethods
		include ActiveModel::Validations

		attribute_method_prefix 'clear_'

		attribute_method_suffix '?'

		def self.attributes(*names)
			attr_accessor(*names)
			define_attribute_methods(names)
			self.attribute_names += names
		end

		def persisted?
			false
		end

		def deliver
			if valid? 
				MailForm::Notifier.contact(self).deliver
			else
				false
			end
		end

		def initialize(attributes = {})
			attributes.each do |attr, value|
				self.public_send("#{attr}=", value)
			end if attributes
		end


		protected 

		def clear_attribute(attribute)
			send("#{attribute}=", nil)
		end

		def attribute?(attribute)
			send(attribute).present?
		end
		# def method_missing(method, *args, &block)
		# if the instance of User class doesn't respond to an attribute
		# the raise the method_missing error 
		#   if respond_to_without_attributes?(method, true)
		#     super
		#   else
		# turn the method into a string, :name => 'name'
		#     match = match_attribute_method?(method.to_s)
		# 
		#     match ? attribute_missing(match, *args, &block) : super
		#   end
		# end
	end
end