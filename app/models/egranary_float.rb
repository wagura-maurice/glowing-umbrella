class EgranaryFloat < ActiveRecord::Base
  belongs_to :user

  def txn_date
    self.created_at.strftime("%d/%m/%y")
  end

end
