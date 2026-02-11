class Time
  def to_formatted_date
    I18n.l(self, format: :date_only)
  end

  def to_formatted_datetime
    I18n.l(self, format: :datetime)
  end
end

class DateTime
  def to_formatted_date
    I18n.l(self, format: :date_only)
  end

  def to_formatted_datetime
    I18n.l(self, format: :datetime)
  end
end

class ActiveSupport::TimeWithZone
  def to_formatted_date
    I18n.l(self, format: :date_only)
  end

  def to_formatted_datetime
    I18n.l(self, format: :datetime)
  end
end
