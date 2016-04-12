class Profile < ActiveRecord::Base
  belongs_to :user

  validates :time_zone,
            inclusion: { in: ActiveSupport::TimeZone.all.map(&:name),
                         message: "%{value} is not a valid time zone" },
            allow_blank: true
  validates :birthday,
            date: { before_or_equal_to: Proc.new { Date.today },
                    message: "must be before or equal to today's date" },
            allow_blank: true

  def age
    return if birthday.nil?
    c_d = Date.today
    b_d = birthday
    if c_d.month < b_d.month || (c_d.month == b_d.month && c_d.day < b_d.day)
      adj = 1
    else
      adj = 0
    end
    c_d.year - b_d.year - adj
  end
end
