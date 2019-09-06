#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_error_report'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin for error report.'
  s.description      = <<-DESC
A new flutter plugin for error report.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { '王柬斐' => 'wangjf01@missfresh.cn' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'Bugly'
  s.static_framework = true

  s.ios.deployment_target = '8.0'
end