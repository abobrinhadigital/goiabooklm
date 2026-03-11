class CreateSolidCableMessages < ActiveRecord::Migration[8.1]
  def up
    # Se a tabela já existir (como no banco de produção que tem schema separado), não faz nada.
    # Mas em desenvolvimento (banco único), ela criará a estrutura necessária.
    return if table_exists?(:solid_cable_messages)

    create_table :solid_cable_messages do |t|
      t.string :channel, null: false
      t.text :payload, null: false
      t.datetime :created_at, precision: 6, null: false

      t.index :channel
      t.index :created_at
    end
  end

  def down
    drop_table :solid_cable_messages if table_exists?(:solid_cable_messages)
  end
end
