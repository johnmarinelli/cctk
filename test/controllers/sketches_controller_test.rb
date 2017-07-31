require 'test_helper'

class SketchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    log_in_as users(:one), 'password1'
  end

  test 'should get new' do
    get new_sketch_url
    assert_response :success
  end

  test 'should get edit' do
    @sketch = sketches :glsl
    get edit_sketch_url(@sketch)
    assert_response :success
  end

  test 'should not create sketch without title' do
    assert_no_difference ['Snippet.count', 'Sketch.count'] do
      post sketches_url, 
           params: {
                     sketch: {
                       title: '', 
                       sketch_type: '', 
                       snippet_attributes: [{ content: '', language: 'glsl'}]}}
    end
  end

  test 'should not create sketch without at least one snippet' do
    assert_no_difference ['Sketch.count'] do
      post sketches_url, 
           params: {
             sketch: {
               title: 'Test Sketch', 
               sketch_type: 'glsl', 
               snippet_attributes: [
               ]
             }
           }
      sketch = assigns :sketch
      assert_not sketch.valid?
      err_str = "can't be blank"
      assert sketch.errors.messages[:snippets].include?(err_str)
    end
  end


  test 'should create sketch' do
    assert_difference ['Snippet.count', 'Sketch.count'], 1 do
      post sketches_url, 
           params: {
             sketch: {
               title: 'Test Sketch', 
               sketch_type: 'glsl', 
               snippets_attributes: [
                 { content: 'glsl snippet', language: 'glsl'}
               ]
             }
           }
    end
  end

  test 'should not update sketch without title' do
    @sketch = sketches :glsl
    snippet = @sketch.snippets.first
    old_title = @sketch.title

    patch sketch_path(@sketch), 
            params: {
              sketch: {
                id: @sketch.id,
                title: '', 
                sketch_type: 'glsl', 
                snippets_attributes: [
                  {  
                     id: snippet.id,
                     content: 'void main(void){}', 
                     language: 'glsl'
                  }
                ]
              }
            }

    @sketch.reload
    assert_equal old_title, @sketch.title
    assert_not flash.empty?
    assert_template 'sketches/edit'
  end

  test 'should not update sketch whose snippet is invalid' do
    @sketch = sketches :glsl
    snippet = @sketch.snippets.first
    old_title = @sketch.title
    old_snippet_content = snippet.content
    old_snippet_language = snippet.language

    patch sketch_path(@sketch), 
            params: {
              sketch: {
                id: @sketch.id,
                title: 'this is a valid title', 
                sketch_type: 'glsl', 
                snippets_attributes: [
                  {  
                     id: snippet.id,
                     content: 'void main(void){}', 
                     language: ''
                  }
                ]
              }
            }

    @sketch.reload

    assert_equal old_title, @sketch.title
    assert_equal old_snippet_language, snippet.reload.language
    assert_equal old_snippet_content, snippet.content
    assert_not flash.empty?
    assert_template 'sketches/edit'
  end

  test 'should update sketch' do
    @sketch = sketches :glsl
    snippet = @sketch.snippets.first

    new_title = 'test GLSL sketch 2'
    new_snippet_content = 'void main(void){}'

    patch sketch_path(@sketch), 
            params: {
              sketch: {
                id: @sketch.id,
                title: new_title, 
                sketch_type: 'glsl', 
                snippets_attributes: [
                  {  
                     id: snippet.id,
                     content: new_snippet_content, 
                     language: 'glsl'
                  }
                ]
              }
            }

    @sketch.reload
    assert_equal new_title, @sketch.title

    assert_equal new_snippet_content, @sketch.snippets.first.content
    assert_not flash.empty?
    assert_empty @sketch.errors.messages
    follow_redirect!
    assert_template 'sketches/edit'
  end
end
