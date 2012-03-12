module Devise
  module Models
    # Extends your User class with support for CAS ticket authentication.
    module CasAuthenticatable
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        # Authenticate a CAS ticket and return the resulting user object.  Behavior is as follows:
        # 
        # * Check ticket validity using RubyCAS::Client.  Return nil if the ticket is invalid.
        # * Return the resulting user object.
        def authenticate_with_cas_ticket(ticket)
          ::Devise.cas_client.validate_service_ticket(ticket) unless ticket.has_been_validated?
          
          if ticket.is_valid?
            conditions = {::Devise.cas_username_column => ticket.respond_to?(:user) ? ticket.user : ticket.response.user} 
						resource = new(conditions)
            resource
          end
        end

				def serialize_into_session(record)
				  [record.username, record.authenticatable_salt]
			  end

				def serialize_from_session(key, salt)
					record = new(:username => key)
					record if record && record.authenticatable_salt == salt
				end
      end
    end
  end
end
