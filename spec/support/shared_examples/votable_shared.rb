require 'rails_helper'

shared_examples_for Votable do
  describe 'Associations' do
    it { should have_many(:votes).dependent(:destroy) }
  end

  describe 'public methods' do
    describe '#total_votes' do
      let!(:vote1) { create(:vote, user: second_user, votable: votable, value: 1) }
      let!(:vote2) { create(:vote, user: third_user, votable: votable, value: 1) }
      let!(:vote3) { create(:vote, user: user, votable: votable, value: -1) }
      it 'count sum values' do
        expect(votable.total_votes).to eq 1
      end
    end

    describe '#vote_up' do
      it 'user votes up one time' do
        votable.vote_up(second_user)

        expect(votable.total_votes).to eq 1

        votable.vote_up(second_user)

        expect(votable.total_votes).to eq 1
      end

      it 'user changes his vote' do
        votable.vote_up(second_user)

        expect(votable.total_votes).to eq 1

        votable.vote_down(second_user)

        expect(votable.total_votes).to eq(-1)
      end
    end

    describe '#vote_down' do
      it 'user votes down one time' do
        votable.vote_down(second_user)

        expect(votable.total_votes).to eq(-1)

        votable.vote_down(second_user)

        expect(votable.total_votes).to eq(-1)
      end

      it 'user changes his vote' do
        votable.vote_down(second_user)

        expect(votable.total_votes).to eq(-1)

        votable.vote_up(second_user)

        expect(votable.total_votes).to eq 1
      end
    end
  end
end
