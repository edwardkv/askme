class SetBackgroundColorDefaultToUsers < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
         User.where(background_color: nil).update_all(background_color: '#106a65')
      end
    end
  end
end
