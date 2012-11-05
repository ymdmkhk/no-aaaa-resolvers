require File.dirname(__FILE__) + '/test_helper.rb'

class TestNoAAAAResolvers < Test::Unit::TestCase
  def setup
  end
  
  def test_resolver_normal
    resolver = NoAAAAResolvers::Resolver.new('192.168.0.0/24','ASXXXX','Japan');
    assert_not_nil(resolver);
    assert_equal(true,resolver.include?('192.168.0.1'))
    assert_equal(true,resolver.include?('192.168.0.0'))
    assert_equal(true,resolver.include?('192.168.0.255'))
    assert_equal(false,resolver.include?('192.168.1.1'))
    assert_equal(IPAddr.new('192.168.0.0/24'),resolver.ip_address)
    assert_equal('ASXXXX',resolver.as)
    assert_equal('Japan',resolver.country)

    no_as_and_no_country_resolver = NoAAAAResolvers::Resolver.new('192.168.0.0/29',nil,nil);
    assert_not_nil(no_as_and_no_country_resolver);
  end

  def test_resolver_no_as_and_no_contry
    resolver = NoAAAAResolvers::Resolver.new('192.168.0.0/24',nil,nil);
    assert_not_nil(resolver);
    assert_equal(nil,resolver.as)
    assert_equal(nil,resolver.country)
  end

  def test_resolvers
    resolvers = NoAAAAResolvers::Resolvers.new([
                                                NoAAAAResolvers::Resolver.new('192.168.0.0/24',nil,nil),
                                                NoAAAAResolvers::Resolver.new('192.168.1.0/24',nil,nil),
                                                NoAAAAResolvers::Resolver.new('10.0.0.0/24',nil,nil),
                                               ])
    assert_not_nil(resolvers);
    assert_equal(3,resolvers.size)
    assert_equal(3,resolvers.length)
    assert_equal(IPAddr.new('192.168.0.0/24'),resolvers.include?('192.168.0.5').ip_address)
    assert_equal(IPAddr.new('10.0.0.0/24'),resolvers.include?('10.0.0.130').ip_address)
    assert_equal(nil,resolvers.include?('172.16.0.1'))
  end

  def test_no_aaaa_resolvers_from_file
    no_aaaa_resolvers = NoAAAAResolvers.new('test/no_aaaa-20121029.txt');
    assert_equal(235,no_aaaa_resolvers.size)
    assert_equal(no_aaaa_resolvers.length,no_aaaa_resolvers.size)
    assert(no_aaaa_resolvers.include?('202.225.11.4'))
    assert_equal(nil,no_aaaa_resolvers.include?('127.0.0.1'))
    assert_equal(IPAddr.new('202.225.11.4/30'),no_aaaa_resolvers.include?('202.225.11.4').ip_address)
    assert_equal('AS2518',no_aaaa_resolvers.include?('202.225.11.4').as)
    assert_equal('Japan',no_aaaa_resolvers.include?('202.225.11.4').country)
    assert(no_aaaa_resolvers.countries['Japan'].include?('202.225.11.4'))
    assert_equal(75,no_aaaa_resolvers.countries['Japan'].size)
    assert_equal(20,no_aaaa_resolvers.countries['United States'].size)
    assert_equal(18,no_aaaa_resolvers.ases['AS2518'].size)
    assert(no_aaaa_resolvers.last_modified_time < Time.now)
  end

  def test_no_aaaa_resolvers_from_http
    no_aaaa_resolvers = NoAAAAResolvers.new
    assert(no_aaaa_resolvers.size >= 3)
    assert(no_aaaa_resolvers.last_modified_time < Time.now)
  end

  def test_no_aaaa_resolvers_from_string
    no_aaaa_resolvers = NoAAAAResolvers.new(<<'END')
# Resolvers to which Google may not return AAAA records.
# Copyright 2012 Google Inc. All Rights Reserved.
# Last updated: 2012-10-29.

192.0.2.0/24
2001:db8::/32
200.28.4.129/32          # AS7418 Chile
201.228.140.4/30         # AS3816 Colombia
200.28.4.130/32          # AS7418 Chile
201.228.139.162/32       # AS3816 Colombia
202.225.11.200/29        # AS2518 Japan
202.216.224.12/31        # AS4691 Japan
201.228.139.189/32       # AS3816 Colombia
201.228.139.161/32       # AS3816 Colombia
202.216.229.12/30        # AS4691 Japan
202.225.11.196/30        # AS2518 Japan
49.129.22.208/29         # AS2518 Japan
49.129.22.200/29         # AS2518 Japan
202.216.224.11/32        # AS4691 Japan
202.216.224.18/32        # AS4691 Japan
202.225.11.4/30          # AS2518 Japan
163.139.230.169/32       # AS2519 Japan
202.225.11.8/30          # AS2518 Japan
163.139.230.167/32       # AS2519 Japan
133.208.10.132/30        # AS2518 Japan
143.90.55.104/30         # AS4725 Japan
143.90.55.100/30         # AS4725 Japan
12.121.112.212/31        # AS7018 United States
12.121.112.210/31        # AS7018 United States
163.139.21.200/31        # AS2519 Japan
163.139.21.198/31        # AS2519 Japan
202.216.224.14/32        # AS4691 Japan
49.129.22.196/30         # AS2518 Japan
219.103.130.58/31        # AS9595 Japan
202.216.224.16/31        # AS4691 Japan
210.130.137.178/31       # AS2497 Japan
61.122.116.147/32        # AS17506 Japan
202.216.0.21/32          # AS4704 Japan
202.225.11.2/31          # AS2518 Japan
133.208.10.130/31        # AS2518 Japan
210.138.175.114/31       # AS2497 Japan
12.121.112.214/32        # AS7018 United States
12.121.112.209/32        # AS7018 United States
202.216.0.53/32          # AS4704 Japan
202.216.229.11/32        # AS4691 Japan
202.216.229.17/32        # AS4691 Japan
210.143.144.11/32        # AS10013 Japan
202.225.11.195/32        # AS2518 Japan
219.103.130.57/32        # AS9595 Japan
124.106.7.145/32         # AS9299 Philippines
190.82.63.129/32         # AS7418 Chile
180.131.127.121/32       # AS38640 Japan
211.132.129.58/31        # AS9595 Japan
202.225.11.12/32         # AS2518 Japan
202.225.11.1/32          # AS2518 Japan
133.208.10.136/32        # AS2518 Japan
133.208.10.129/32        # AS2518 Japan
218.85.157.20/32         # AS4134 China
202.247.0.244/30         # AS2518 Japan
84.246.88.10/32          # AS33885 Sweden
156.154.98.93/32         # AS12008 United States
131.107.112.12/32        # AS3598 United States
49.129.22.216/32         # AS2518 Japan
49.129.22.195/32         # AS2518 Japan
220.254.3.5/32           # AS18268 Japan
211.132.129.57/32        # AS9595 Japan
202.208.174.177/32       # AS7511 Japan
202.208.174.145/32       # AS7511 Japan
194.63.239.164/32        # AS8248 Greece
202.75.4.254/32          # AS17564 Malaysia
14.139.5.10/32           # AS55824 India
219.122.96.78/32         # AS18274 Japan
61.213.209.161/32        # AS17534 Japan
84.238.0.130/32          # AS33796 Denmark
166.111.8.28/31          # AS4538 China
219.243.224.5/32         # AS4538 China
194.29.137.1/32          # AS12464 Poland
218.223.68.73/32         # AS18068 Japan
61.220.5.42/31           # AS3462 Taiwan
162.105.129.26/31        # AS4538 China
41.204.164.3/32          # AS36914 Kenya
210.32.156.138/32        # AS4538 China
131.231.16.7/32          # AS786 United Kingdom
202.120.2.101/32         # AS4538 China
207.46.52.142/32         # AS8069 Taiwan
121.194.2.2/32           # AS4538 China
157.158.0.4/32           # AS8508 Poland
202.229.78.240/32        # AS2514 Japan
202.229.78.239/32        # AS2514 Japan
130.39.254.28/32         # AS2055 United States
219.105.32.32/32         # AS18097 Japan
192.100.77.2/32          # AS9464 Thailand
218.219.161.2/32         # AS17961 Japan
95.87.0.12/32            # AS38924 Bulgaria
202.247.192.227/32       # AS17955 Japan
41.89.1.4/32             # AS36914 Kenya
218.104.227.194/32       # AS4837 China
143.106.2.5/32           # AS53187 Brazil
202.216.97.11/32         # AS7505 Japan
202.120.127.219/32       # AS4538 China
202.233.0.133/32         # AS4675 Japan
130.192.119.1/32         # AS137 Italy
203.217.178.254/32       # AS17564 Malaysia
158.108.2.67/32          # AS9411 Thailand
220.208.130.6/32         # AS18282 Japan
202.114.0.242/32         # AS4538 China
61.208.178.3/32          # AS4713 Japan
202.98.18.3/32           # AS4837 China
61.220.5.22/32           # AS3462 Taiwan
189.112.102.18/32        # AS16735 Brazil
61.220.5.21/32           # AS3462 Taiwan
61.220.5.56/32           # AS3462 Taiwan
140.146.22.66/32         # AS2381 United States
195.110.50.52/32         # AS196729 Poland
202.202.0.33/32          # AS4538 China
202.116.160.32/32        # AS4538 China
199.190.222.66/32        # AS32360 United States
221.228.255.68/32        # AS4134 China
218.104.227.190/32       # AS4837 China
202.222.129.35/32        # AS18085 Japan
189.44.66.16/32          # AS10429 Brazil
61.7.7.125/32            # AS18150 Japan
196.43.133.5/32          # AS21491 Uganda
165.76.16.2/32           # AS4725 Japan
85.120.204.98/32         # AS2614 Romania
200.189.112.42/32        # AS19723 Brazil
210.229.64.1/32          # AS9370 Japan
200.189.112.41/32        # AS19723 Brazil
80.118.192.100/32        # AS15557 France
213.129.96.1/32          # AS24923 Russia
210.142.137.10/32        # AS17528 Japan
194.85.32.18/32          # AS3267 Russia
164.128.36.74/32         # AS3303 Switzerland
80.254.79.157/32         # AS24889 Switzerland
129.70.204.148/31        # AS680 Germany
94.245.126.18/32         # AS8075 United Kingdom
58.20.46.201/32          # AS4837 China
194.138.212.13/32        # AS10962 United States
202.112.112.200/32       # AS4538 China
147.230.16.140/32        # AS2852 Czech Republic
159.226.8.25/32          # AS7497 China
195.245.233.2/32         # AS25373 Slovakia
212.122.192.34/32        # AS8326 Poland
159.226.8.26/32          # AS7497 China
150.217.1.32/32          # AS137 Italy
192.160.130.18/32        # AS20306 United States
202.112.14.151/32        # AS4538 China
212.113.161.226/31       # AS12542 Portugal
211.68.2.1/32            # AS4538 China
159.226.8.29/32          # AS7497 China
165.93.11.4/32           # AS2907 Japan
200.51.83.134/32         # AS10834 Argentina
200.91.32.44/32          # AS28048 Argentina
210.39.0.33/32           # AS4538 China
209.251.129.4/32         # AS10674 United States
202.113.16.10/32         # AS4538 China
195.216.210.10/32        # AS44884 Ukraine
202.194.14.12/32         # AS4538 China
202.119.32.6/32          # AS4538 China
219.149.135.178/32       # AS17883 China
187.49.0.6/32            # AS28138 Brazil
194.27.49.1/32           # AS8517 Turkey
87.238.232.1/32          # AS30936 Russia
202.113.15.1/32          # AS4538 China
202.119.24.12/32         # AS4538 China
210.34.0.18/32           # AS4538 China
131.175.1.4/32           # AS137 Italy
190.169.30.2/32          # AS19192 Venezuela
218.223.36.8/32          # AS18070 Japan
163.16.1.12/32           # AS1659 Taiwan
153.20.24.71/32          # AS9877 Singapore
209.244.4.106/32         # AS3356 United States
202.112.144.236/32       # AS4538 China
189.45.34.2/32           # AS25933 Brazil
193.55.130.2/32          # AS2200 France
210.157.0.1/32           # AS7506 Japan
156.17.93.253/32         # AS8970 Poland
202.112.20.131/32        # AS4538 China
202.203.208.33/32        # AS4538 China
161.69.31.20/32          # AS7754 United States
202.201.0.133/32         # AS4538 China
61.188.4.55/32           # AS4134 China
208.85.151.4/32          # AS19073 United States
200.93.227.5/32          # AS27947 Ecuador
153.20.24.72/32          # AS9877 Singapore
131.112.181.30/32        # AS9367 Japan
84.238.6.254/32          # AS33796 Denmark
129.106.9.82/32          # AS5707 United States
158.125.1.100/32         # AS786 United Kingdom
202.114.88.10/32         # AS4538 China
12.120.120.140/32        # AS7018 United States
138.236.128.36/32        # AS17234 United States
210.229.63.2/32          # AS9601 Japan
202.205.80.132/32        # AS4538 China
202.15.112.34/32         # AS2506 Japan
200.34.44.227/32         # AS8151 Mexico
94.245.126.34/32         # AS8075 United Kingdom
194.63.237.4/32          # AS8248 Greece
202.115.64.33/32         # AS4538 China
202.38.64.56/32          # AS4538 China
217.169.229.5/32         # AS15466 Netherlands
202.120.111.3/32         # AS4538 China
202.38.64.1/32           # AS4538 China
147.8.235.73/32          # AS4528 Hong Kong
219.113.19.202/32        # AS17675 Japan
210.229.63.1/32          # AS9601 Japan
202.112.80.168/32        # AS4538 China
147.8.165.13/32          # AS4528 Hong Kong
210.233.168.10/32        # AS9352 Japan
212.90.160.2/32          # AS12593 Ukraine
202.120.224.6/32         # AS4538 China
93.186.16.156/32         # AS18705
132.250.1.131/32         # AS48 United States
202.112.170.10/32        # AS4538 China
202.32.219.40/32         # AS2497 Japan
202.204.48.8/32          # AS4538 China
202.137.240.2/32         # AS9876 New Zealand
210.27.80.2/32           # AS4538 China
211.64.142.6/32          # AS4538 China
182.148.202.73/32        # AS4134 China
176.31.244.121/32        # AS16276
158.108.196.2/32         # AS9411 Thailand
109.254.49.6/32          # AS20590 Ukraine
133.49.4.1/32            # AS2907 Japan
210.45.240.99/32         # AS4538 China
202.195.128.10/32        # AS4538 China
202.119.32.12/32         # AS4538 China
220.178.4.195/32         # AS4134 China
109.254.49.34/32         # AS20590 Ukraine
79.142.240.10/32         # AS50821 Sweden
202.116.81.166/32        # AS4538 China
64.114.134.2/32          # AS852 Canada
163.28.136.2/32          # AS1659 Taiwan
211.130.170.5/32         # AS4713 Japan
200.189.112.32/32        # AS19723 Brazil
195.234.226.245/32       # AS25275 Switzerland
193.255.88.1/32          # AS8517 Turkey
63.85.219.10/32          # AS33745 United States
202.112.80.106/32        # AS4538 China
END
    assert_equal(235,no_aaaa_resolvers.size)
    assert(no_aaaa_resolvers.last_modified_time < Time.now)
  end

  def test_no_aaaa_resolvers_from_string_force
    no_aaaa_resolvers = NoAAAAResolvers.new(<<'END',:string)
http://www.google.com/intl/en_ALL/ipv6/statistics/data/no_aaaa.txt
# Resolvers to which Google may not return AAAA records.
# Copyright 2012 Google Inc. All Rights Reserved.
# Last updated: 2012-10-29.

192.0.2.0/24
2001:db8::/32
200.28.4.129/32          # AS7418 Chile
END
    assert_equal(3,no_aaaa_resolvers.size)
    assert(no_aaaa_resolvers.last_modified_time < Time.now)
  end

end
