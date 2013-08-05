require 'socket'
require 'resolv'


module ChefExt
  module JettyHelpers
    def resolvable?(addr)
      Resolv::DNS.new.getaddress(addr)
      true
    rescue
      false
    end

    def accessible_hostname
      candidates = []
      candidates << node["cloud"]["public_hostname"] if node["cloud"] and node["cloud"]["public_hostname"]
      candidates += [node["fqdn"], Socket.gethostname] 
      candidates.find(&:resolvable?) || node["ipaddress"]
    end
  end
end
