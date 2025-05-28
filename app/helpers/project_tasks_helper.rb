module ProjectTasksHelper
  def status_label(status)
    case status
    when 0 then "未着手"
    when 1 then "着手中"
    when 2 then "完了"
    else "不明"
    end
  end
end
