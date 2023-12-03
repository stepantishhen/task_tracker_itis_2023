module Mutations
  class DestroyUser < BaseMutation
    argument :id, ID, required: true

    type Types::Payloads::UserPayload

    def resolve(**options)
      user = ::User.find(options[:id])

      # Remove after implement
      authorize!

      result = Users::Destroys::DestroyRecord.call(user: user)

      result.to_h.merge(errors: formatted_errors(result.user))
    end
  end
end
