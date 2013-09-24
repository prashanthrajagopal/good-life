class GroupsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @groups = current_user.groups.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(params[:group])
    @group.user_groups.build(:user_id=>current_user.id)
      if @group.save
        redirect_to new_invitation_path, notice: 'Group was successfully created you can now invite friends to the group below'
      else
        render action: "new"
      end
  end

  def update
    @group = Group.find(params[:id])
     if @group.update_attributes(params[:group])
        redirect_to @group, notice: 'Group was successfully updated.'
     else
      render action: "edit"
     end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to groups_url
  end
end
