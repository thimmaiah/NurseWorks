class AddPoToStagginRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :staffing_requests, :po_for_invoice, :string, limit: 30
  end
end
