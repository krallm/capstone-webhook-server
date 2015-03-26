require 'cocaine'
require 'json'
require 'sinatra'

# Todo: Handle cases where two pushes are sent almost simultaneously

post '/payload' do
  begin
    push = JSON.parse(request.body.read)
  rescue
    puts 'Error parsing \'push\' JSON'
    return
  end

  # Todo: Verify that payload is from GitHub

  cmd = Cocaine::CommandLine.new('sh', 'on_push.sh')
  cmd.run
end
