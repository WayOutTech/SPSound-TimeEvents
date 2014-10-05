#
# Be sure to run `pod spec lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "SPSound+TimeEvents"
  s.version          = "0.0.2"
  s.summary          = "A Sparrow extension for adding seek/event control to the Sparrow-Framework sound system."
  s.license          = 'MIT'
  s.author           = { "Johnathan Raymond" => "johnathan.raymond@wayouttech.com" }
  s.source           = { :git => "https://github.com/WayOutTech/SPSound-TimeEvents.git", :tag => s.version.to_s }
  s.platform         = :ios, '5.0'
  s.homepage         = 'http://wayouttech.com'
  s.requires_arc = true

  s.source_files = 'Classes/**/*.{h,m}'
  s.exclude_files = 'Classes/**/TPPreciseTimer.{h,m}'
  s.resources = 'Assets'

  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'

  s.subspec 'TPPreciseTimer' do |timer|
      timer.source_files = 'Classes/**/TPPreciseTimer.{h,m}',
      timer.ios.exclude_files = 'Classes/osx'
      timer.osx.exclude_files = 'Classes/ios'
      timer.requires_arc = false
  end

  s.dependency 'Sparrow', '2.1'

end
