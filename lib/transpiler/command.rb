module Transpiler
  class Command

    attr_reader :data, :error

    def initialize(data = {})
      self.data = data
      valid?
    end

    def valid?
      !data.empty? && (data.keys - required_fields).empty?
    end

    def required_fields
      []
    end

    def from_change
      raise NoMethodError
    end

    def to_change
      raise NoMethodError
    end

    def from_protocol_v1
      raise NoMethodError
    end

    def to_protocol_v1
      raise NoMethodError
    end

    def from_protocol_v2
      raise NoMethodError
    end

    def to_protocol_v2
      raise NoMethodError
    end
  end
end
