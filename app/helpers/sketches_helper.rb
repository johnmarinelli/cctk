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
          url: 'https://aframe.io/releases/0.6.1/aframe.min.js',
        },
        {
          url: 'https://unpkg.com/aframe-particle-system-component@1.0.x/dist/aframe-particle-system-component.min.js'
        },
        {
          url: 'https://unpkg.com/aframe-extras.ocean@%5E3.5.x/dist/aframe-extras.ocean.min.js'
        },
        {
          url: 'https://unpkg.com/aframe-gradient-sky@1.0.4/dist/gradientsky.min.js'
        },
        {
          url: 'https://unpkg.com/aframe-animation-component@3.2.1/dist/aframe-animation-component.min.js'
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
