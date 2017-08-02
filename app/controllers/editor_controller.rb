class EditorController < ApplicationController

  # auto save updates with remote: true
  def refresh_sketch
    id = editor_params[:id]
    language = editor_params[:language]
    content = editor_params[:content]
    s = Snippet.find id

    rms = session[:recently_modified_sketches] || {}
    rms[id] = { language: language, content: content }

    respond_to do |format|
      if s.update_attributes language: language, content: content
        format.json { render json: 1, status: :ok }
        format.html
      else
        format.json { render json: 0, status: :unprocessable_entity }
        format.html
      end
    end
  end

  private
    def editor_params
      params.permit(:id, :content, :language)
    end
end
