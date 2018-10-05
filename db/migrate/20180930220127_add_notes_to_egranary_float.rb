class AddNotesToEgranaryFloat < ActiveRecord::Migration
  def change
    add_column :egranary_floats, :notes, :text
  end
end
