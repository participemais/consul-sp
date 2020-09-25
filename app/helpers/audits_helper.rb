module AuditsHelper
  def truncate_audit_value(resource, field, value)
    truncate(audit_value(resource, field, value), length: 50)
  end

  def audit_value(resource, field, value)
    if value.is_a?(Array)
      value.join(",")
    elsif resource.type_for_attribute(field.to_s).type == :boolean
      resource.class.human_attribute_name("#{field}_#{value}")
    elsif value.present?
      resource.class.human_attribute_name(value)
    end
  end
end
