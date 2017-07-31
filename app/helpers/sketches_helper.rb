module SketchesHelper
  def get_sources_for_sketch_type(sketch_type)
    if sketch_type == 'glsl'
      [
        {
          url: 'https://cdnjs.cloudflare.com/ajax/libs/three.js/86/three.js'
        }
      ]
    elsif sketch_type == 'webvr'
      [
        {
          url: "https://aframe.io/releases/0.6.1/aframe.min.js"
        }
      ]
    elsif sketch_type == 'processing'
      [
        {
          url: 'https://cdnjs.cloudflare.com/ajax/libs/p5.js/0.5.11/p5.js'
        }
      ]
    end
  end
end
