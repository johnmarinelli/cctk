require 'test_helper'

class EditorRefreshSketchTest < ActionDispatch::IntegrationTest
  test 'editor gets refreshed on changed html' do
    # navigate to page with sketch editor layout
    @sketch = sketches :webvr
    get edit_sketch_path @sketch

    # type some stuff in to html snippet
    assert_select '#text-editor-html'

    snippet = @sketch.snippets.where(language: 'html').first
    new_snippet_content = '<body></body>'

    get refresh_sketch_path, 
            xhr: true,
            params: {
              id: snippet.id,
              language: snippet.language,
              content: new_snippet_content
            }
    
    assert_response :ok
  end
end
