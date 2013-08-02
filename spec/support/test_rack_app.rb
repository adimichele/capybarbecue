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
        <div id='hidden_text'>I am <span id='hidden_portion' style='display:none;'>hidden </span>text</div>
        <form id='testform'>
          <input type='text' name='text_field' id='text_field' value='monkeys'></input>
          <input type='text' name='disabled_text' id='disabled_text' disabled='1'></input>
          <select name='select_field' id='select_field' multiple='1'>
            <option value="volvo" id='volvo'>Volvo</option>
            <option value="saab" id='saab'>Saab</option>
            <option value="mercedes" id='mercedes'>Mercedes</option>
            <option value="audi" id='audi'>Audi</option>
          </select>
          <input type='checkbox' id='checkbox_field' name='checkbox_field' value='raisins'></input>
        </form>
        <iframe id='myframe' name='myframe' src='/iframe'>
        </iframe>
      </body>
    </html>
    HTML
  end

  def call(env)
    request = Rack::Request.new(env)
    if request.path == '/iframe'
      [200, {"Content-Type" => "text/html"}, ["<html><body><div id='inframe'></div></body></html>"]]
    else
      [200, {"Content-Type" => "text/html"}, [get_html(request)]]
    end
  end
end