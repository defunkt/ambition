ActiveRecord::Schema.define(:version => 0) do
  create_table :users, :force => true do |t|
    t.column :name,       :string
    t.column :type,       :string
    t.column :salary,     :integer,  :default => 70_000
    t.column :created_at, :datetime, :null => false
    t.column :updated_at, :datetime, :null => false
  end

  create_table :replies, :force => true do |t|
    t.column :content,    :string
    t.column :topic_id,   :integer
    t.column :created_at, :datetime, :null => false
    t.column :updated_at, :datetime, :null => false
  end

  create_table :topics, :force => true do |t|
    t.column :project_id, :integer
    t.column :title,      :string
    t.column :subtitle,   :string
    t.column :content,    :text
    t.column :created_at, :datetime, :null => false
    t.column :updated_at, :datetime, :null => false
  end

  create_table :projects, :force => true do |t|
    t.column :name, :string
  end

  create_table :developers_projects, :force => true do |t|
    t.column :developer_id, :integer
    t.column :project_id,   :integer
    t.column :joined_on,    :datetime
    t.column :access_level, :integer, :default => 1
  end

  create_table :companies, :force => true do |t|
    t.column :name,    :string
    t.column :rating,  :integer
  end
end
