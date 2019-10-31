class CreateAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :answers do |t|
      t.text :body
      t.boolean :best, default: false
      t.timestamps
    end
    add_reference(:answers, :question, foreign_key: true)
  end
end
