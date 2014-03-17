class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.text :description
      t.integer :video_id, :user_id
      t.timestamps
    end
  end
end
