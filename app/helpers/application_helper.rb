module ApplicationHelper
  def full_title(page_title = "")
    base_title = "Odinbook"
    page_title.empty? ? base_title : page_title + " | " + base_title
  end

  def formatted_birthday(birthday)
    birthday.strftime("%B %-d, %Y")
  end
end
