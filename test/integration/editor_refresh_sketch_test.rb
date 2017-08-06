require 'test_helper'

class EditorRefreshSketchTest < ActionDispatch::IntegrationTest
  test 'editor gets refreshed on changed html' do
    # navigate to page with sketch editor layout
    @sketch = sketches :webvr
    snippet = @sketch.snippets.where(language: 'html').first
    old_html_content = snippet.content

    get edit_sketch_path @sketch
    new_snippet_content = '<div class="test">goodbye</div>'

    get refresh_sketch_path, 
            xhr: true,
            params: {
              id: snippet.id,
              language: snippet.language,
              html_content: new_snippet_content,
              js_content: @sketch.snippets.where(language: 'javascript').first
            }
    
    assert_response :ok
    assert_template 'sketches/_sketch'

    # make sure db wasn't written to
    snippet.reload
    assert_equal old_html_content, snippet.content
  end
end
