require 'rails_helper'

RSpec.describe Authorization, type: :model do
  #let!(:user) { create(:user) }
  #subject { create(:authorization) }

  it { should belong_to(:user) }

  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid }
  #it { should validate_uniqueness_of(:provider).scoped_to(:uid) }

end
