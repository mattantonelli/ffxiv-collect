module RecordsHelper
  def format_record_number(record)
    record.order.to_s.rjust(2, '0')
  end

  def record_rarity(record)
    stars(record.rarity)
  end
end
