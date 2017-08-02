class Sketch < ApplicationRecord
  belongs_to :user, optional: true
  has_many :snippets, dependent: :destroy
  accepts_nested_attributes_for :snippets, allow_destroy: true, reject_if: :all_blank

  before_save :validate_code

  validates :title, presence: true

  # at least one snippet
  validates :snippets, presence: true

  # SketchesController#create, update
  enum status: {
    unsaved: 0,
    saved: 1
  }

  # set defaults unless this is an update transaction
  after_initialize :set_defaults, unless: :persisted?

  private
    DEFAULT_WEBVR_HTML_CONTENT = <<-HTML
<a-scene>
<a-camera keyboard-controls>
  <a-entity cursor
            position="0 0 -1"
            geometry="primitive: ring; radiusInner: 0.02; radiusOuter: 0.03;"
            material="color: #CCC; shader: flat;">
  </a-entity> 
</a-camera>
<a-entity id="sphere" geometry="primitive: sphere"
          material="color: #EFEFEF; shader: flat"
          position="0 0.15 -5"
          light="type: point; intensity: 5"
          animation="property: position; easing: easeInOutQuad; dir: alternate; dur: 1000; to: 0 -0.10 -5; loop: true"></a-entity>

<a-entity id="ocean" ocean="density: 20; width: 50; depth: 50; speed: 4"
          material="color: #9CE3F9; opacity: 0.75; metalness: 0; roughness: 1"
          rotation="-90 0 0"></a-entity>

<a-entity id="sky" theta-length="100" geometry="primitive: sphere; radius: 1000"
          material="shader: gradient; topColor:254 210 29; bottomColor: 48 35 104;"
          scale="-1 1 1"></a-entity>
</a-scene>
    HTML

    DEFAULT_WEBVR_JS_CONTENT = <<-JS
var a = 1;
    JS

    def set_status_saved
      self.status = 'saved'
    end

    def set_defaults
      self.status = 0
      self.title = generate_random_title
      self.sketch_type = 'webvr'
      self.snippets.build language: :html, 
                          content: DEFAULT_WEBVR_HTML_CONTENT

      self.snippets.build language: :javascript, 
                          content: DEFAULT_WEBVR_JS_CONTENT
    end

    def generate_random_title
      # TODO: some cute shit
      'Sample Sketch'
    end
  
    # TODO; server side code linting
    def validate_code
      true
    end
end
