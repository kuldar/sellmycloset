class ChangeTransactionDefaultStatus < ActiveRecord::Migration[5.0]
  def change
    change_column_default :transactions, :status, from: 1, to: 0
  end
end
