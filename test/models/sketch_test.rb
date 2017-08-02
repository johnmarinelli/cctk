require 'test_helper'

class SketchTest < ActiveSupport::TestCase
  def setup
    @sketch = sketches :glsl
  end

  test 'sketch is invalid without title' do
    @sketch.title = ''
    assert_not @sketch.valid?
  end

  test 'sketch is invalid without snippet' do
    @sketch.snippets = []
    assert_not @sketch.valid?
  end

  test 'sketch has two snippets' do
    @sketch.snippets = []
    assert_difference 'Snippet.count', 2 do 
      snippet_a = @sketch.snippets.build content: 'empty', language: 'glsl'
      snippet_b = @sketch.snippets.build content: 'empty', language: 'glsl'

      snippet_a.save!
      snippet_b.save!
    end

    assert_equal 2,  @sketch.snippets.count
  end

  test 'new test defaults to webvr' do
    sketch = Sketch.new

    assert_equal 'webvr', sketch.sketch_type
    assert_equal 'unsaved', sketch.status

  end

  test 'new test has 2 snippets' do
    sketch = Sketch.new
    sketch.save
    assert_equal 2, sketch.snippets.count
  end

end
