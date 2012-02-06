class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.timestamps
    end
    add_column :images, :url, :string
    add_column :images, :width, :string
    add_column :images, :height, :string
    add_column :images, :content_type, :string
    add_column :images, :image_blob, :binary
  end
end
