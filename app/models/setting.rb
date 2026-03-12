class Setting < ApplicationRecord
  validates :key, presence: true, uniqueness: true

  def self.get(key, default = nil)
    setting = find_by(key: key)
    return default unless setting
    
    parse_value(setting.value)
  end

  def self.set(key, value)
    setting = find_or_initialize_by(key: key)
    setting.value = value.is_a?(Hash) || value.is_a?(Array) ? value.to_json : value.to_s
    setting.save!
  end

  private

  def self.parse_value(value)
    return value if value.blank?
    
    JSON.parse(value)
  rescue JSON::ParserError
    value
  end
end
