require 'messages/list_message'

module VCAP::CloudController
  class ProcessesListMessage < ListMessage
    register_allowed_keys [
      :app_guid,
      :types,
      :space_guids,
      :organization_guids,
      :app_guids,
      :guids,
    ]

    validates_with NoAdditionalParamsValidator # from BaseMessage

    validates :app_guids, array: true, allow_nil: true
    validate :app_nested_request, if: -> { app_guid.present? }

    def self.from_params(params)
      opts = params.dup
      %w(types space_guids organization_guids app_guids guids).each do |param|
        to_array!(opts, param)
      end
      new(opts.symbolize_keys)
    end

    def to_param_hash
      super(exclude: [:app_guid])
    end

    private

    def app_nested_request
      invalid_guids = []
      invalid_guids << :app_guids if app_guids
      invalid_guids << :organization_guids if organization_guids
      invalid_guids << :space_guids if space_guids
      errors.add(:base, "Unknown query parameter(s): '#{invalid_guids.join("', '")}'") if invalid_guids.present?
    end
  end
end
