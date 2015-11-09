shared_examples 'requires authenticated user' do
  before do
    clear_current_user
    action
  end

  it 'redirect the the root page' do
    expect(response).to redirect_to root_path
  end

  it 'sets the error-flash' do
    expect(flash['error']).to be_present
  end
end

