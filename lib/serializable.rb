# frozen_string_literal: true

# Moduel Definiiton:
module Serializable
  def to_yaml_format
    YAML.dump(to_h)
  end
end
