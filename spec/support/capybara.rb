# encoding: utf-8

def set_host (host)
  host! host
  Capybara.app_host = "http://" + host
end

def visit_with_port(path)
  port_number = Capybara.current_session.server.try(:port)
  if port_number
    visit("http://127.0.0.1:#{port_number}#{path}")
  else
    visit root_path
  end
end

def login user
  visit_with_port(root_path)

  within 'form.b-login-form' do
    fill_in 'email', :with => user.email
    fill_in 'password', :with => '12345678'

    find(:xpath, 'input[@type="submit"]').click
  end
end

def retry_on_timeout(n = 3, &block)
  block.call
rescue Capybara::ElementNotFound => e
  if n > 0
    puts "Catched error: #{e.message}. #{n-1} more attempts."
    retry_on_timeout(n - 1, &block)
  else
    raise e
  end
end
