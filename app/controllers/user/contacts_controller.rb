class User::ContactsController < ApplicationController

    def new
        @contact = Contact.new
    end

    def confirm
        @contact = Contact.new(contact_params)
        if @contact.invalid?
            render :new
        else
            render :confirm
        end
    end
    
    def confirmback
        redirect_to new_contact_path
    end

    def back
        @contact = Contact.new(contact_params)
        render :new
    end

    def create
        
        @contact = Contact.new(contact_params)
        if @contact.save
          ContactMailer.send_mail(@contact).deliver_now
          redirect_to done_path
        else
          render :new
        end
    end    

    def done
    end

    private

        def contact_params
            params.require(:contact).permit(:email, :name, :message)
        end
end
