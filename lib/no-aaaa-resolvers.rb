$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

class NoAAAAResolvers
  VERSION = '0.0.1'

  class Resolver
    require 'ipaddr'
    def initialize(ip_address,as,country)
      @ip_address = IPAddr.new(ip_address)
      @as = as
      @country = country
    end
    attr_reader :ip_address, :as, :country
    def include?(ip_address)
      @ip_address.include?(ip_address)
    end
  end

  class Resolvers
    def initialize(resolvers = [])
      @resolvers = resolvers
    end
    def push(element)
      @resolvers.push(element)
    end
    def each
      @resolvers.each{|resolver|
        yield(resolver)
      }
    end
    def length
      @resolvers.length
    end
    def size
      @resolvers.size
    end
    def include?(ip_address)
      @resolvers.each{|resolver|
        return resolver if resolver.include?(ip_address)
      }
      nil
    end
  end

  class Source
    def initialize(source,source_type)
      if :string == source_type then
        require 'stringio'
        @file = StringIO.new(source)
        @last_modified_time = Time.now
        return
      end
      if source[0,7] == 'http://' then
        require 'open-uri'
        @file = open(source)
        @last_modified_time = @file.last_modified
        return
      end
      begin
        @file = open(source)
        @last_modified_time = @file.mtime
      rescue
        require 'stringio'
        @file = StringIO.new(source)
        @last_modified_time = Time.now
      end
    end
    def each 
      @file.each{|line|
        yield(line)
      }
    end
    def close
      @file.close
      @last_modified_time = nil
    end
    attr_reader :file,:last_modified_time
  end

  def initialize(source_string = 'http://www.google.com/intl/en_ALL/ipv6/statistics/data/no_aaaa.txt',source_type = nil)
    @main = Resolvers.new
    @countries = Hash.new
    @ases = Hash.new
    source = Source.new(source_string,source_type)
    @last_modified_time = source.last_modified_time
    parse(source)
  end
  def include?(ip_address)
    return @main.include?(ip_address)
  end
  def size
    return @main.size
  end
  def length
    return @main.length
  end
  attr_reader :countries,:ases,:last_modified_time
  def each
    @main.each{|resolver|
      yield(resolver)
    }
  end
  private
  def parse(source)
    source.each {|line|
      resolver = parse_line(line)
      next unless resolver
      @main.push(resolver)
      if resolver.country then
        @countries[resolver.country] = Resolvers.new unless @countries[resolver.country]
        @countries[resolver.country].push(resolver)
      end
      if resolver.as then
        @ases[resolver.as] = Resolvers.new unless @ases[resolver.as]
        @ases[resolver.as].push(resolver)
      end
    }
    source.close
  end
  private
  def parse_line(line)
    regex = Regexp.new('^([0-9a-zA-Z\.:]+/[0-9]+)(?:\s*#\s)?(AS\d+)?\s*(.*)$') 
    if regex =~ line then
      resolver = Resolver.new($1,$2,$3)
      return resolver if resolver
    end
    return nil
  end
end
