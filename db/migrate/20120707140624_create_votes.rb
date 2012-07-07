class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :count, :null => false
    end

    # populate the db with some sample data
    Vote.create(:id => 1, :count => 3)
    Vote.create(:id => 2, :count => 4)
    Vote.create(:id => 3, :count => 1)
    Vote.create(:id => 4, :count => 6)
    Vote.create(:id => 5, :count => 9)
    Vote.create(:id => 6, :count => 3)
  end
end
