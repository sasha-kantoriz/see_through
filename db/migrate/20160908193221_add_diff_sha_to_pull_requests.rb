class AddDiffShaToPullRequests < ActiveRecord::Migration
  def change
    add_column :pull_requests, :diff_sha, :string, :null => true
    add_column :pull_requests, :diff_updated, :string, :null => true
  end
end
