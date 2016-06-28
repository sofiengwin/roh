class Item < Roh::BaseModel
  to_table :item
  property :id, type: :integer, primary_key: true
  property :title, type: :text, nullable: false
  property :body, type: :text, nullable: false
  property :todo_id, type: :integer, nullable: false
  property :created_at, type: :text, nullable: false
  create_table

  belongs_to :todo, foreign_key: :todo_id, class_name: "Todo"

  validates :title, uniqueness: true

  validates :title, format: { with: /./, on: :create }

  validates :title, presence: true
  validates :body, presence: true
  validates :status, presence: true

  validates :title, length: { max: 50, min: 5 }
  validates :body, length: { max: 100, min: 10 }
end
