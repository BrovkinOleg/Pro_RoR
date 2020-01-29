ThinkingSphinx::Index.define :answer, with: :active_record do
  indexes body, sortable: true
  indexes user.email, as: :author, sortable: true

  has user_id, question_id, created_at, updated_at
end
