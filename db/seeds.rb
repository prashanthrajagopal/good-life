puts 'CREATING SEEDS'
Role.create([
  { :name => 'admin' }, 
  { :name => 'user' }, 
  { :name => 'superuser' }
], :without_protection => true)
user = User.create! :name => 'test', :email => 'test@test.com', :password => '123456', :password_confirmation => '123456'
user2 = User.create! :name => 'production', :email => 'production@test.com', :password => '123456', :password_confirmation => '123456'
user.add_role :admin
user2.add_role :superuser
Group.create! :name => 'test group' , :description =>'description for test group'
Group.create! :name => 'test group2' , :description =>'description for test group2'
UserGroup.create! :group_id =>1, :user_id =>1
UserGroup.create! :group_id =>1, :user_id =>2
UserGroup.create! :group_id =>2, :user_id =>1
UserGroup.create! :group_id =>2, :user_id =>2
Bill.create!("purpose"=>"test bill 1", "total"=>"123", "bill_date"=>"08 December 2012", "group_id"=>"1", "bill_splits_attributes"=>{"0"=>{"user_id"=>"1", "paid_amount"=>"100", "_destroy"=>"false"}, "1355938059420"=>{"user_id"=>"1", "paid_amount"=>"23", "_destroy"=>"false"}})
Bill.create!("purpose"=>"treasure", "total"=>"1024", "bill_date"=>"05 December 2012", "group_id"=>"1", "bill_splits_attributes"=>{"0"=>{"user_id"=>"2", "paid_amount"=>"24", "_destroy"=>"false"}, "1355938111047"=>{"user_id"=>"1", "paid_amount"=>"999", "_destroy"=>"false"}, "1355938110438"=>{"user_id"=>"1", "paid_amount"=>"1", "_destroy"=>"false"}})
puts 'SEEDS CREATED'