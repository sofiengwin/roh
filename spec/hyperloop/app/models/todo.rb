class Todo < Roh::BaseModel
  to_table :todo
  property :id, type: :integer, primary_key: true
  property :title, type: :text, nullable: false
  property :body, type: :text, nullable: false
  property :status, type: :text, nullable: false
  property :created_at, type: :text, nullable: false
  create_table

  validates :title, uniqueness: true

  # validates :title, format: {
  #   with: /d{3}/, on: :create
  #  }

  validates :title, presence: true
  validates :body, presence: true
  validates :status, presence: true

  validates :title, length: { max: 50, min: 5 }
  validates :body, length: { max: 300, min: 10 }
end
