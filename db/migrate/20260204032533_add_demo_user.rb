class AddDemoUser < ActiveRecord::Migration[7.1]
  def up
    # password_digest = BCrypt::Password.create("1234")

    # execute <<~SQL
    #   INSERT INTO users (name, email, password_digest, created_at, updated_at)
    #   VALUES (
    #     'Default User',
    #     'default@example.com',
    #     '#{password_digest}',
    #     NOW(),
    #     NOW()
    #   )
    #   ON CONFLICT (email) DO NOTHING;
    # SQL
  end

  def down
    execute <<~SQL
      DELETE FROM users WHERE email = 'default@example.com';
    SQL
  end
end
