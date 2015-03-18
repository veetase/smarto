class SubscribersController < ApplicationController

	def new
		@subscriber = Subscriber.new
	end

	def create
		@subscriber = Subscriber.new(subscriber_params)
		if @subscriber.save
			#UserMailer.send_email('1', @subscriber).deliver_now
  			redirect_to root_path
  		else
  			render 'new'
  		end
	end
	
	def show
		@subscriber = Subscriber.find(params[:id])
	end

	def index
		@subscribers = Subscriber.all
	end

	def edit
		@subscriber = Subscriber.find(params[:id])
	end

	def update
		@subscriber = Subscriber.find(params[:id])

		if @subscriber.update(subscriber_params)
			redirect_to @subscriber
		else
			render 'edit'
		end

	end

	def destroy
		@subscriber = Subscriber.find(params[:id])
		@subscriber.destroy
		redirect_to subscribers_path
	end

	#def group_send(comment)
		#@subscribers = Subscriber.all
		#@subscribers.each do |subscriber|
			#UserMailer.send_email('1', subscriber.email).deliver_now
		#end
	#end
	
	
	private
		def subscriber_params
			params.require(:subscriber).permit(:email)
		end
end
