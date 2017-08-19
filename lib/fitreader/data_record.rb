class DataRecord < FitObject
  attr_reader :fields, :global_num

  def initialize(io, definition)
    @global_num = definition.global_msg_num
    @fields = Hash[definition.field_definitions.map do |f|
      opts = {base_num: f.base_num,
              size: f.size,
              arch: definition.endian}
      [f.field_def_num, DataField.new(io, opts)]
    end]
    if definition.dev_defs
      @dev_fields = Hash[definition.dev_defs.map do |f|
        opts = {base_num: f.field_def[:base_type_id].raw,
                size: f.size,
                arch: definition.endian}
        [f.field_def[:field_name].raw.to_sym, DataField.new(io, opts)]
      end]
    end
  end

  def valid
    @fields.select { |_, v| v.valid }
  end

  def dev_fields
    if defined? @dev_fields
      @dev_fields
    else
      Hash.new
    end
  end
end
