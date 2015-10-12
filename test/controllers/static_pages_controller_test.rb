require "test_helper"

class StaticPagesControllerTest < ActionController::TestCase
  def test_home
    get :home
    assert_response :success
  end

  def test_about
    get :about
    assert_response :success
  end

  def test_contact
    get :contact
    assert_response :success
  end

end
