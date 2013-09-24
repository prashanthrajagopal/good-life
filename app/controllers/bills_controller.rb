class BillsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
    bill_ids = BillSplit.where(:user_id => current_user.id).map(&:bill_id).uniq
    @bills = Bill.where(Bill.arel_table[:id].in(bill_ids))
  end

  def new
    @bill = Bill.new
    @bill.bill_splits.build
    @user = current_user
  end

  def show
    @bill = Bill.find(params[:id])
  end

  def create
    @user = current_user
    @bill = Bill.new(params[:bill])
    @bill.user_id = @user.id
    # raise params[:bill].inspect
    if @bill.save  
      redirect_to @bill, :notice => "Successfully created bill."  
    else  
      render :new  
    end  
  end

  def update
    @user = current_user
    @bill = Bill.find(params[:id])  
    if @bill.update_attributes(params[:bill])
      redirect_to @bill, :notice => "Successfully updated Bill." 
    else
      render :edit
    end  
  end

  def edit
    @bill = Bill.find(params[:id])
    @user = current_user
  end

  def destroy
    @bill = Bill.find(params[:id])
    @bill.deleted = true
    @bill.save!
    #@bill.destroy
    redirect_to bills_url
    flash[:notice] = "Successfully deleted Bill."
    #render :index
  end

  def get_users
    @users = Group.find(params[:group_id]).users
    render :partial => "users", :locals => { :users => @users }
  end

  def create_bill
    @bill = Bill.new
    @user = current_user
    @bill.group_id = params[:group_id].chomp()
    @bill.purpose = params[:purpose].chomp()
    @bill.total = params[:total].chomp()
    @bill.bill_date = params[:bill_date].chomp()
    @bill.users_list =  JSON.parse(params[:users_list])
    @bill.user_id = @user.id
    @bill.save!
    redirect_to @bill, :notice => "Successfully created bill."  
  end

  def edit_bill
    users_list = {}
    @user = current_user
    @bill = Bill.find(params[:id])
    @bill.purpose = params[:purpose].chomp()
    @bill.total = params[:total].chomp()
    @bill.bill_date = params[:bill_date].chomp()
    tmp_users_list =  JSON.parse(params[:users_list])
    tmp_users_list.each do |k,v|
      users_list[":user_"+User.where(:email => k).first.id.to_s] = v
    end  
    @bill.users_list =  users_list
    @bill.save!
    redirect_to @bill, :notice => "Successfully edited bill."  
  end
end
