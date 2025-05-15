module XIVAPI
  extend self

  def sheet(name)
    XIVAPI::Sheet.new(name)
  end
end
