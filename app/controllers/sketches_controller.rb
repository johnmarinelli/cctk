class SketchesController < ApplicationController
  before_action :logged_in_user, only: [:destroy]
  before_action :set_sketch, only: [:show, :edit, :update]

  def show
  end

  def new
    @sketch = Sketch.new
  end

  def create
    @sketch = Sketch.new sketch_params

    respond_to do |format|
      if @sketch.save
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
  end
  
  def update
    respond_to do |format|
      if @sketch.update(sketch_params)
        flash[:success] = 'Sketch updated.'
        format.html { redirect_to @sketch }
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
    
    def sketch_params
      params.require(:sketch).permit(:title, :sketch_type, snippets_attributes: [:id, :content, :language], user: [:id])
    end

    def set_sketch
      @sketch = Sketch.find params[:id]
    end
end
