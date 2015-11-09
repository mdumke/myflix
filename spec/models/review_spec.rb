require 'spec_helper'

describe Review do
  it { should belong_to(:video) }
  it { should have_db_column(:video_id) }
  it { should have_db_index(:video_id) }
  it { should belong_to(:user) }
  it { should have_db_column(:user_id) }
  it { should have_db_index(:user_id) }
  it { should validate_presence_of(:text) }
  it { should validate_presence_of(:rating) }
end

