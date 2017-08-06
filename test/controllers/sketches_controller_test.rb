require 'test_helper'

class SketchesControllerTest < ActionDispatch::IntegrationTest

  test 'should get new' do
    get new_sketch_url
    assert_response :success
    assert_template 'sketches/new'
    assert_template layout: :editor
  end

  test 'should get show and use compiled sketch layout' do
    sketch = sketches :webvr
    get sketch_url sketch
    assert_template layout: :compiled_sketch
    assert_select '.test', text: 'hello'
 end

  test 'should get index, and index should link to edit sketches' do
    get sketches_url
    assert_response :success

    Sketch.all.each do |sketch|
      assert_select "a[href=?]", edit_sketch_path(sketch)
    end
  end

  test 'should get edit and use editor layout' do
    @sketch = sketches :glsl
    get edit_sketch_url(@sketch)
    assert_response :success
    assert_template layout: :editor
  end

  test 'should not create sketch without title' do
    sketch = Sketch.new

    # undo sketch defaults
    sketch.title = ''
    sketch.sketch_type = ''
    sketch.save validate: false

    assert_no_difference ['Snippet.count', 'Sketch.count'] do
      post sketches_url, 
           params: {
                     sketch: {
                       id: sketch.id,
                       title: sketch.title, 
                       sketch_type: sketch.sketch_type, 
                       snippet_attributes: [{ content: '', language: 'glsl'}]}}
    end
  end

  test 'should not create sketch without at least one snippet' do
    sketch = Sketch.new
    sketch.title = 'Test Sketch'
    sketch.sketch_type = 'glsl'
    sketch.snippets = []
    sketch.save validate: false

    assert_no_difference ['Sketch.count'] do
      post sketches_url, 
           params: {
             sketch: {
               id: sketch.id,
               title: sketch.title,
               sketch_type: sketch.sketch_type, 
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
    assert_differences [['Sketch.count', 1], 
                        ['Snippet.count', 2]] do
      sketch = Sketch.new
      sketch.title = 'Test Sketch'
      sketch.sketch_type = 'glsl'
      sketch.save validate: false

      post sketches_url, 
           params: {
             sketch: {
               id: sketch.id,
               title: sketch.title, 
               sketch_type: sketch.sketch_type, 
               snippets_attributes: [
                  { 
                    id: sketch.snippets.first.id, 
                    content: 'glsl snippet', 
                    language: 'glsl'
                  }
               ]
             }
           }
      sketch.reload
      assert_equal 'saved', sketch.status
      assert_equal 'glsl', sketch.snippets.first.language
    end
  end

  test 'should not update sketch without title' do
    @sketch = sketches :glsl
    snippet = @sketch.snippets.first
    old_title = @sketch.title
    old_status = @sketch.status

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
    assert_equal old_status, @sketch.status
    assert_not flash.empty?
    assert_template 'sketches/edit'
  end

  test 'should not update sketch whose snippet is invalid' do
    @sketch = sketches :glsl
    snippet = @sketch.snippets.first
    old_title = @sketch.title
    old_snippet_content = snippet.content
    old_snippet_language = snippet.language
    old_status = @sketch.status

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
    assert_equal old_status, @sketch.status
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
    assert_equal 'saved', @sketch.status
    follow_redirect!
    assert_template 'sketches/edit'
  end

end
