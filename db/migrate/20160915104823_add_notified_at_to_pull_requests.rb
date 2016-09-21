class AddNotifiedAtToPullRequests < ActiveRecord::Migration
  def change
    add_column :pull_requests, :notified_at, :string, :null => true
  end
end
