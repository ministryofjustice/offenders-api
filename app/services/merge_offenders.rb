module MergeOffenders
  module_function

  def call(offender_merge_from, offender_merge_to, merge_params)
    ActiveRecord::Base.transaction do
      Identity.where(id: merge_params[:identity_ids].split(','))
              .update_all(offender_id: offender_merge_to.id)
      Identity.where(id: identity_ids_to_be_deleted(offender_merge_from, offender_merge_to, merge_params))
              .update_all(status: Identity::STATUSES[:deleted])
      offender_merge_to.update!(current_identity_id: merge_params[:current_identity_id])
      offender_merge_from.update!(merged_to_id: offender_merge_to.id)
    end
  end

  class << self
    private

    def previous_identity_ids(offender_merge_from, offender_merge_to)
      offender_merge_to.identities.pluck(:id) | offender_merge_from.identities.pluck(:id)
    end

    def identity_ids_to_be_deleted(offender_merge_from, offender_merge_to, merge_params)
      previous_identity_ids(offender_merge_from, offender_merge_to) - merge_params[:identity_ids].split(',')
    end
  end
end
