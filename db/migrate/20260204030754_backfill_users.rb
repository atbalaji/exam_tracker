class BackfillUsers < ActiveRecord::Migration[7.1]
  def up
    password_digest = BCrypt::Password.create("1234")
    execute <<~SQL
      UPDATE users
      SET password_digest = '#{password_digest}'
      WHERE password_digest IS NULL
    SQL
  end
end
