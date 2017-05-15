class DataField < FitObject
  TYPES = {
    0=>{:size=>1, :unpack_type=>'C', :endian=>0, :invalid=>255},
    1=>{:size=>1, :unpack_type=>"c", :endian=>0, :invalid=>127},
    2=>{:size=>1, :unpack_type=>"C", :endian=>0, :invalid=>255},
    3=>{:size=>2, :unpack_type=>{:big=>"s>", :little=>"s<"}, :endian=>1, :invalid=>32767},
    4=>{:size=>2, :unpack_type=>{:big=>"S>", :little=>"S<"}, :endian=>1, :invalid=>65535},
    5=>{:size=>4, :unpack_type=>{:big=>"l>", :little=>"l<"}, :endian=>1, :invalid=>2147483647},
    6=>{:size=>4, :unpack_type=>{:big=>"L>", :little=>"L<"}, :endian=>1, :invalid=>4294967295},
    7=>{:size=>1, :unpack_type=>"Z*", :endian=>0, :invalid=>0},
    8=>{:size=>4, :unpack_type=>{:big=>"e", :little=>"g"}, :endian=>1, :invalid=>4294967295},
    9=>{:size=>8, :unpack_type=>{:big=>"E", :little=>"G"}, :endian=>1, :invalid=>18446744073709551615},
    10=>{:size=>1, :unpack_type=>"C", :endian=>0, :invalid=>0},
    11=>{:size=>2, :unpack_type=>{:big=>"S>", :little=>"S<"}, :endian=>1, :invalid=>0},
    12=>{:size=>4, :unpack_type=>{:big=>"L>", :little=>"L<"}, :endian=>1, :invalid=>0},
    13=>{:size=>1, :unpack_type=>nil, :endian=>0, :invalid=>255}
  }

  def initialize(io, d, arch)
    @field_def_num = d[:field_def_num]
    base = TYPES[d[:base_num]]
    char = d[:endianness].zero? ? base[:unpack_type] : base[:unpack_type][arch]
    binding.pry if char.nil?
    @value = read_multiple(io, char, d[:size], base[:size])
  end
end
