class CreateAudios < ActiveRecord::Migration[7.0]
  def change
    create_table :audios do |t|
      t.string :to_string
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
