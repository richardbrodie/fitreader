require 'test_helper'

class FitreaderTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Fitreader::VERSION
  end

  def test_reads_a_garmin_file
    path = "test/files/working_garmin.fit"
    file = File.open(path, "r")
    fit = Fit.new file
    digest = {file_id: 1,
              file_creator: 1,
              device_settings: 1,
              user_profile: 1,
              sensor_info: 5,
              sport: 1,
              zones_target: 1,
              record: 4988,
              event: 120,
              device_info: 30,
              source: 43,
              segment_lap: 2,
              lap: 1,
              session: 1,
              activity: 1,
              battery_info: 20}
    assert_equal fit.digest, digest
  end

  def test_reads_a_wahoo_file
    path = "test/files/working_wahoo.fit"
    file = File.open(path, "r")
    fit = Fit.new file
    digest = {file_id: 1,
              event: 12,
              device_info: 10,
              sport: 1,
              workout: 1,
              record: 715,
              mfg_range_min: 5,
              lap: 1,
              session: 1,
              activity: 1}
    assert_equal fit.digest, digest
  end

  def test_reads_a_wahoo_file_with_dev_fields
    path = "test/files/working_wahoo_dev_fields.fit"
    file = File.open(path, "r")
    fit = Fit.new file
    digest = {file_id: 1,
              developer_data_id: 1,
              field_description: 1,
              event: 288,
              device_info: 139,
              sport: 1,
              workout: 1,
              record: 5652,
              mfg_range_min: 30,
              lap: 1,
              session: 1,
              activity: 1}
    assert_equal fit.digest, digest
  end
end
