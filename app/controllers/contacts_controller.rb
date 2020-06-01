class ContactsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :contacts_params, except: [:create]


  respond_to :json

  def index
    respond_with(@contacts)
  end

  def show
    respond_with(@contact)
  end

  def new
    @contact = Contact.new
    respond_with(@contact)
  end

  def edit
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.user_id = current_user.id
    @contact.save
    respond_with(@contact)
  end

  def update
    @contact.update(contact_params)
    respond_with(@contact)
  end

  def destroy
    @contact.destroy
    respond_with(@contact)
  end

  private

    def contact_params
      params.require(:contact).permit(:name, :phone, :email, :relationship, :user_id, :contact_type)
    end
end
