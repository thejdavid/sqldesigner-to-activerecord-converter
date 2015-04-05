class CreateConverters < ActiveRecord::Migration
  def change
    create_table :converters do |t|

      t.timestamps null: false
    end
  end
end
