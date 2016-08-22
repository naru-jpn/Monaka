@version = "0.0.2"

Pod::Spec.new do |s|
  s.name                  = "Monaka"
  s.version               = @version
  s.summary               = "Monaka is a Library to convert swifty values and NSData each other to support immutable data handling."
  s.homepage              = "https://github.com/naru-jpn/Monaka"
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { "naru" => "tus.naru@gmail.com" }
  s.source                = { :git => "https://github.com/naru-jpn/Monaka.git", :tag => @version }
  s.source_files          = 'Sources/*.swift'
  s.ios.deployment_target = '9.0'
end
