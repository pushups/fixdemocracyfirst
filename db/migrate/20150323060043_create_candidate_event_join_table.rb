class CreateCandidateEventJoinTable < ActiveRecord::Migration
  def change
    create_join_table :candidates, :events do |t|
      t.index [:candidate_id, :event_id]
      t.index [:event_id, :candidate_id]
    end
  end
end
