class Rack::Attack
  throttle("req/ip", limit: 30, period: 1.minute) do |req|
    req.ip # unless req.path.start_with?('/assets')
  end
end
