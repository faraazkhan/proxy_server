require 'rack-proxy'
class ProxyServer < Rack::Proxy
  COMPANY_PROFILE_PATH = '/HIOS-REST/hioshcsvc/dataretrievalservice.svc/v4.0'
  FINDER_PATH = '/RBIS-API/v5.6/REST'
  HOST = 'hiosvalgateway.cms.gov'

  def rewrite_env(env)
    request = Rack::Request.new(env)
    env["HTTP_HOST"] = HOST
    env["rack.url_scheme"] = "https"
    env["SERVER_PORT"] = 443
    env["HTTPS"] = "on"
    if request.host =~ /finder/
      env["PATH_INFO"] = FINDER_PATH + env["PATH_INFO"]
      env["REQUEST_PATH"] = FINDER_PATH + env["REQUEST_PATH"]
    else
      env["PATH_INFO"] = COMPANY_PROFILE_PATH + env["PATH_INFO"]
      env["REQUEST_PATH"] = COMPANY_PROFILE_PATH + env["REQUEST_PATH"]
    end
    env
  end
end

run ProxyServer.new(:streaming => false)

  
