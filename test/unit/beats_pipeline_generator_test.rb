require 'minitest/autorun'
require_relative '../../lib/beats_pipeline_generator'

class BeatsPipelineGeneratorTest < Minitest::Test
  def test_copy_and_rename_pipeline
    mapping = {
      'old1' => { source_field: 'old1', destination_field: 'new1', rename: 'copy' },
      'old2' => { source_field: 'old2', destination_field: 'new2', rename: 'rename' },
      'old3' => { source_field: 'old3', destination_field: 'new3', rename: 'copy' },
    }
    pl = generate_beats_pipeline(mapping)
    copy_processor = pl[0]
    rename_processor = pl[1]
    assert_equal(
      { 'copy_fields' => {
          'fields' => [ {'from' => 'old1', 'to' => 'new1'}, {'from' => 'old3', 'to' => 'new3'} ],
          'ignore_missing' => true, 'fail_on_error' => false
      } },
      copy_processor
    )
    assert_equal(
      { 'rename' => {
          'fields' => [ {'from' => 'old2', 'to' => 'new2'} ],
          'ignore_missing' => true, 'fail_on_error' => false
      } },
      rename_processor
    )
  end

  def test_non_renamed_beats
    mapping = {
      'field1' => { source_field: 'field1', destination_field: 'field1', rename: 'copy' },
      'field2' => { source_field: 'field2', destination_field: nil, rename: 'copy' },
    }
    pl = generate_beats_pipeline(mapping)
    assert_equal([], pl, "No rename processor should be added when there's no rename to perform")
  end

end