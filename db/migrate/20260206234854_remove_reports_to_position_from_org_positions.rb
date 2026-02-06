class RemoveReportsToPositionFromOrgPositions < ActiveRecord::Migration[8.0]
  def change
    remove_column :org_positions, :reports_to_position_id, :bigint
  end
end
