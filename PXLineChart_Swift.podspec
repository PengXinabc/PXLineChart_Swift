
Pod::Spec.new do |s|


  s.name         = "PXLineChart_Swift"
  s.version      = "0.1"
  s.summary      = "一个简单的可左右滑动的折线走势图"
  s.homepage     = "https://github.com/PengXinabc/PXLineChart_Swift"

  s.license      = "MIT (example)"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             =  "彭欣" 
  s.platform     = :ios, "8.0"


  s.source       = { :git => "https://github.com/PengXinabc/PXLineChart_Swift.git", :tag => "#{s.version}" }

  s.source_files  = "PXLineChart_Swift/LineChart/*.swift"

end
