module ApplicationHelper
  def rating_options_for_videos(selected = nil)
    options_for_select(
      [5, 4, 3, 2, 1].map { |n| [pluralize(n, 'Star'), n] },
      selected)
  end
end
