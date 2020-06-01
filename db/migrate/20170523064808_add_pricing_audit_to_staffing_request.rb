class AddPricingAuditToStaffingRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :staffing_requests, :pricing_audit, :text
  end
end
