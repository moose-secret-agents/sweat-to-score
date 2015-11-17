class AddImgurLinkToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :imgurLink, :string
  end
end
