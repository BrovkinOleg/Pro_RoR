
require 'sphinx_helper'

RSpec.describe 'SearchService class' do
  describe '.call' do
    let(:query) { 'my_query' }

    describe 'search in scopes' do
      SearchService::SCOPES.each do |search_scope|
        it "call search in #{search_scope}" do
          expect(search_scope.singularize.classify.constantize).to receive(:search).with(query)
          SearchService.call(query, search_scope)
        end
      end
    end

    describe 'when' do
      it 'call search with value not_in_scope' do
        expect(ThinkingSphinx).to receive(:search).with(query)
        SearchService.call(query, 'not_in_scope')
      end
    end

    describe 'when' do
      it 'call search with scope is nil' do
        expect(ThinkingSphinx).to receive(:search).with(query)
        SearchService.call(query, nil)
      end
    end
  end
end
