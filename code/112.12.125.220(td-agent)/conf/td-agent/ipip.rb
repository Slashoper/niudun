# encoding: utf-8

module SeventeenMon
  class IPDBX
  
    private_class_method :new
  
    def ip_db_path
      @ip_db_path ||= File.expand_path'../ipip.datx', __FILE__
    end
  
    def ip_db
      @ip_db ||= File.open ip_db_path, 'rb'
    end
  
    def offset
      @offset ||= ip_db.read(4).unpack("Nlen")[0]
    end
  
    def index
      @index ||= ip_db.read(offset - 4)
    end
  
    def max_comp_length
      @max_comp_length ||= offset - 262144 - 4
    end
  
    def self.instance
      @instance ||= self.send :new
    end
  
    def seek(_offset, length)
      IO.read(ip_db_path, length, offset + _offset - 262144).split "\t"
    end
  end
  
  class IP
    attr_reader :ip
  
    # Initialize IP object
    #
    # == parameters:
    # params::
    #   Might contain address(hostname) and protocol, or just IP
    #
    # == Returns:
    # self
    #
    def initialize(params = {})
      @ip = params[:ip] ||
        Socket.getaddrinfo(params[:address], params[:protocol])[0][3]
    end
  
    def four_number
      @four_number ||= begin
        fn = ip.split(".").map(&:to_i)
        raise "ip is no valid" if fn.length != 4 || fn.any?{ |d| d < 0 || d > 255}
        fn
      end
    end
  
    def ip2long
      @ip2long ||= ::IPAddr.new(ip).to_i
    end
  
    def packed_ip
      @packed_ip ||= [ ip2long ].pack 'N'
    end
  
    def find
      tmp_offset = (four_number[0] * 256 + four_number[1]) * 4
      start = IPDBX.instance.index[tmp_offset..(tmp_offset + 3)].unpack("V")[0] * 9 + 262144
  
      index_offset = -1
  
      while start < IPDBX.instance.max_comp_length
        if IPDBX.instance.index[start..(start + 3)] >= packed_ip
          index_offset = "#{IPDBX.instance.index[(start + 4)..(start + 6)]}\x0".unpack("V")[0]
          index_length = IPDBX.instance.index[(start + 8)].unpack("C")[0]
          break
        end
        start += 9
      end
  
      return "N/A" unless index_offset
  
      result = IPDBX.instance.seek(index_offset, index_length).map do |str|
        str.encode("UTF-8", "UTF-8")
      end
  
    {
      country: result[0],
      province: result[1],
      city: result[2],
      carrier: result[4],
      latitude: result[5],
      longitude: result[6],
    }
    end
  end
end

module SeventeenMon
  require "socket"
  require "ipaddr"

  def self.find_by_ip(_ip)
    IP.new(ip: _ip).find
  end
end

#SM = SeventeenMon

#rs=SM.find_by_ip $*[0]
#p rs
