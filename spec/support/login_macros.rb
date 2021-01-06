module LoginMacros
  def login(user)
    visit login_path
    fill_in 'email', with: user.email
    fill_in 'password', with: 'password'
    click_button 'Login'
    expect(page).to have_content 'Login successful'
  end

  def logout
    click_link 'Logout'
    expect(page).to have_content 'Logged out'
  end
end
