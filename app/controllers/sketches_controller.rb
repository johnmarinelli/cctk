class SketchesController < ApplicationController
  before_action :logged_in_user, only: [:destroy]
  before_action :set_sketch, only: [:show, :create, :edit, :update]

  def index
    @sketches = Sketch.all.paginate(page: params[:page])
  end

  def show
    @html_snippet = @sketch.snippets.find_by(language: :html)
    @js_snippet = @sketch.snippets.find_by(language: :javascript)
    render layout: 'compiled_sketch'
  end

  def new
    @sketch = Sketch.new
    @sketch.title = 'Sample sketch'
    @sketch.sketch_type = :webvr
    @sketch.save
    
    render layout: 'editor'
  end

  def create
    @sketch = Sketch.find sketch_params[:id]
    @sketch.update_attributes sketch_params.except(:id)

    respond_to do |format|
      if @sketch.save
        update_sketch_status :saved
        flash[:info] = "#{@sketch.title} saved."
        format.html { render :show }
        format.json { render json: @sketch, callback: 'sketchCreated' }
      else
        flash[:danger] = "#{@sketch.title} not saved."
        format.html { render :new }
        format.json { render json: @sketch.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    render layout: 'editor'
  end
  
  def update
    respond_to do |format|
      if @sketch.update(sketch_params)
        update_sketch_status :saved
        
        flash[:success] = 'Sketch updated.'
        format.html { redirect_to edit_sketch_url(@sketch) }
        format.json { render :show, status: :ok, location: @sketch }
      else
        flash[:danger] = 'Sketch could not be updated.'
        format.html { render :edit }
        format.json { render json: @sketch.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy

  end

  private

    def update_sketch_status(status)
      @sketch.update_attribute :status, status.to_s
    end
    
    def sketch_params
      params.require(:sketch).permit(:id, :title, :sketch_type, snippets_attributes: [:id, :content, :language], user: [:id])
    end

    def set_sketch
      @sketch = Sketch.find params[:id] || sketch_params[:id]
    end
end
