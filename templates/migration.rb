class CreateIdentifiers
  def self.up
    create_table(:identifiers) do |t|
	  t.column :user_id, :integer
	  t.column :identifier, :string
	end
  end
  
  def self.down
     drop_table :identifiers
  end
end