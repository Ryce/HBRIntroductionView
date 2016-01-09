Pod::Spec.new do |s|
  s.name         = 'HBRIntroductionView'
  s.version      = '1.0.0'
  s.summary      = 'A controller for building custom app introductions and tutorials.'
  s.homepage     = 'https://github.com/ryce/HBRIntroductionView'

  s.description  = 'A super-charged version of MYIntroductionView for building custom app introductions and tutorials.'

  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Hamon Riazy" => "hamon.riazy@gmail.com" }

  s.source       = { :git => "https://github.com/ryce/HBRIntroductionView.git", 
                     :tag => "1.0.0" }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Source/*.*'
  s.frameworks = 'QuartzCore'
end
