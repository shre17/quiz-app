class AddJsonFieldToSubmissions < ActiveRecord::Migration[5.1]
  def change
    add_column :submissions, :form_values, :jsonb, null: false, default: '{}'
  end
end
