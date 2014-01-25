require 'test_helper'

class ContactMessagesControllerTest < ActionController::TestCase
  setup do
    @contact_message = contact_messages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contact_messages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contact_message" do
    assert_difference('ContactMessage.count') do
      post :create, contact_message: { email: @contact_message.email, message: @contact_message.message, name: @contact_message.name, subject: @contact_message.subject }
    end

    assert_redirected_to contact_message_path(assigns(:contact_message))
  end

  test "should show contact_message" do
    get :show, id: @contact_message
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @contact_message
    assert_response :success
  end

  test "should update contact_message" do
    patch :update, id: @contact_message, contact_message: { email: @contact_message.email, message: @contact_message.message, name: @contact_message.name, subject: @contact_message.subject }
    assert_redirected_to contact_message_path(assigns(:contact_message))
  end

  test "should destroy contact_message" do
    assert_difference('ContactMessage.count', -1) do
      delete :destroy, id: @contact_message
    end

    assert_redirected_to contact_messages_path
  end
end
