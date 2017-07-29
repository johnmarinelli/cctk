first_user = User.create!(name: 'testuser', 
             email: 'test@email.com', 
             password: 'password', 
             password_confirmation: 'password',
             admin: true,
             activated: true,
             activated_at: Time.zone.now)
# sketches
glsl_sketch = first_user.sketches.build(sketch_type: 'glsl', title: 'Test GLSL Sketch')
prc_sketch = first_user.sketches.build(sketch_type: 'processing', title: 'Test Processing Sketch')
webvr_sketch = first_user.sketches.build(sketch_type: 'webvr', title: 'Test WebVR Sketch')

# snippets
glsl_snippet = glsl_sketch.snippets.build content: 'void main(){}', language: 'glsl'
prc_snippet = prc_sketch.snippets.build content: 'void setup(){} void draw(){}', language: 'javascript'
webvr_html_snippet = webvr_sketch.snippets.build content: '<div>test</div>', language: 'html'
webvr_js_snippet = webvr_sketch.snippets.build content: 'function(){console.log("hello");}', language: 'javascript'

glsl_sketch.save!
prc_sketch.save!
webvr_sketch.save!

glsl_snippet.save!
prc_snippet.save!
webvr_html_snippet.save!
webvr_js_snippet.save!

#99.times do |n|
#  name  = Faker::Name.name
#  email = "example-#{n+1}@railstutorial.org"
#  password = "password"
#  User.create!(name:  name,
#               email: email,
#               activated: true,
#               password:              password,
#               password_confirmation: password)
#end
#
## get first six users
#users = User.order(:created_at)
#users_with_posts = users.take 6
#
## microposts
#50.times do
#  content = Faker::Lorem.sentence 5
#  users_with_posts.each { |u| u.microposts.create!(content: content) }
#end
#
## relationships
#user = first_user
#following = users[0..99]
#followers = users[3..40]
#following.each { |followed| user.follow followed }
#followers.each { |follower| follower.follow user }
