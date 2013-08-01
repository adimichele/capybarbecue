require 'rack'

class TestRackApp
  def get_html(request)
    <<-HTML % request.path
    <html>
      <head><title>Test Rack App</title></head>
      <body>
        <h1>%s</h1>
        <div class='divclass1' id='div1'>
          <div class='divclass2' id='div2'>
            <a href='/link/1' id='link1'>click1</a>
          </div>
        </div>
        <div class='divclass1' id='div3'>
          <div class='divclass2' id='div4'>
            <a href='/link/2' id='link2'>click2</a>
          </div>
        </div>
      </body>
    </html>
    HTML
  end

  def call(env)
    request = Rack::Request.new(env)
    [200, {"Content-Type" => "text/html"}, [get_html(request)]]
  end
end