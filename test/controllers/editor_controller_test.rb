require 'test_helper'

class EditorControllerTest < ActionDispatch::IntegrationTest
  # auto updater in editor
  test 'should update sketch via xhr' do
    @sketch = sketches :glsl
    snippet = @sketch.snippets.first

    new_title = 'test GLSL sketch 2'
    new_snippet_content = 'void main(void){}'

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
