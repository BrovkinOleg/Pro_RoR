class SearchService
  SCOPES = %w[Question Answer Comment User].freeze

  def self.call(query, scope = nil)
    klass = ThinkingSphinx
    klass = scope.classify.constantize if SCOPES.include?(scope)

    escaped_query = ThinkingSphinx::Query.escape(query)
    klass.search escaped_query
  end
end
