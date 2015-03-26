require 'cocaine'
require 'json'
require 'sinatra'

# Todo: Handle cases where two pushes are sent almost simultaneously
# Potential Issue: Executing `sh on_push.sh` blocks, so the HTTP response
#                  isn't sent until the script completes.

set :bind, '0.0.0.0'
set :port, 3090

post '/payload' do
  request.body.rewind
  payload_body = request.body.read
  verify_signature(payload_body)

  begin
    push = JSON.parse(payload_body)
  rescue
    puts 'Error parsing \'push\' JSON'
    return
  end

  # Only update if 'live' branch was pushed to
  # Should match branch name in config.sh
  if push.has_key?('ref') and push['ref'] == 'refs/heads/live'
    cmd = Cocaine::CommandLine.new('sh', 'on_push.sh')
    cmd.run
  end
end

def verify_signature(payload_body)
  signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['SECRET_TOKEN'], payload_body)
  return halt 500, "Signatures didn't match!" unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
end
