
require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #search' do
    it 'search in all' do
      expect(ThinkingSphinx).to receive(:search).with 'test'
      get :search, params: { search_string: 'test', search_scope: 'All' }
    end

    SearchService::SCOPES.each do |scopes|
      it "search in scopes" do
        scope = scopes.singularize
        expect(scope.constantize).to receive(:search).with 'test'
        get :search, params: { search_string: 'test', search_scope: "#{scope}s" }
      end
    end
  end
end
