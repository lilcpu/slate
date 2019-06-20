# use Rack::Static,
#     :urls => ['/docs'],
#     :root => 'build',
#     :index => 'index.html',

use Rack::Static, :urls => {"/" => 'index.html'}, :root => 'build'

run lambda { |env|
  [
    200,
    {
      'Content-Type'  => 'text/html',
      'Cache-Control' => 'public, max-age=86400'
    },
    File.open('build/index.html', File::RDONLY)
  ]
}