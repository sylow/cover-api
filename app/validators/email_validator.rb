# app/validators/email_validator.rb
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank? && options[:allow_blank]
    
    unless valid_email?(value)
      record.errors.add(attribute, message)
    end
  end

  private

  def valid_email?(value)
    # Basic format validation
    email_regex = /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\z/
    return false unless value =~ email_regex

    # Domain specific validations
    local_part, domain = value.split('@')
    
    # Local part validations
    return false if local_part.length > 64
    return false if local_part.start_with?('.') || local_part.end_with?('.')
    return false if local_part.include?('..')

    # Domain validations
    return false if domain.length > 255
    return false if domain.start_with?('-') || domain.end_with?('-')
    
    # TLD validation (at least 2 chars)
    return false unless domain =~ /\.[A-Za-z]{2,}\z/

    # Validate each domain part
    domain.split('.').each do |part|
      return false if part.length > 63
      return false unless part =~ /\A[A-Za-z0-9-]+\z/
    end

    true
  end

  def message
    options[:message] || "is not a valid email address"
  end
end