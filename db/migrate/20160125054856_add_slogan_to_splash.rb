class AddSloganToSplash < ActiveRecord::Migration
  def change
    add_column(:splashes, :slogan, :string)
  end
end
