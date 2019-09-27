#
#  Be sure to run `pod spec lint SwyftSdk.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "SwyftSdk"
  spec.version      = "1.0.7-beta"
  spec.summary      = "A SDK to integrate in with Swyft Vision Stores."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  spec.description  = <<-DESC "A mobile sdk to integrate to allow a client application to authorize and register against swyft systems and a vision storea."
                   DESC

  spec.homepage     = "http://www.swyft.com"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See https://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  spec.license      = "MIT"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  spec.author             = { "tommanuelswyft" => "tmanuel@dropspot.com" }
  # spec.social_media_url   = "https://twitter.com/tommanuelDS"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  spec.platform     = :ios, "12.1"
  
  spec.swift_version = '4.2'
  #spec.platform     = :ios, "12.0"

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

 spec.source       = { :git => "https://tommanuelswyft@github.com/swyftstore/swyft-app-ios-sdk.git", :tag => "#{spec.version}" }
#  spec.source       = { :http => "https://github.com/swyftstore/swyft-app-ios-sdk-cocoa-pod/raw/master/SwyftSdk/1.0.5-beta/SwyftSdk.zip" }
  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  spec.source_files  = "SwyftSdk/**/*.{swift,m,h}"
  #spec.exclude_files = "SwyftSdk/Internals/**/*"

  # spec.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  spec.resources = "SwyftSdk/**/*.{png,jpeg,jpg,storyboard,xib,xcassets,json}"
  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  spec.requires_arc = true
  spec.static_framework = true

  # Moya
  spec.dependency 'Moya', '~> 12.0.1'
  #XML Mapper
  spec.dependency 'XMLMapper', '~> 1.5.3'
  
  # CryptoSwift
  spec.dependency 'CryptoSwift', '~> 1.0.0'
  
  # Firebase
  spec.dependency 'Firebase/Core', '~> 6.5.0'
  spec.dependency 'Firebase/Firestore', '~> 6.5.0'
  spec.dependency 'Firebase/Auth', '~> 6.5.0' 
  
  #JVFloatLabeledTextField
  spec.dependency 'JVFloatLabeledTextField', '~> 1.2.1'
  
  #SwiftTryCatch
  spec.dependency 'SwiftTryCatch', '~> 0.0.1'

  #SipHash 
  spec.dependency 'SipHash', '~> 1.2'

  # spec.dependency "JSONKit", "~> 1.4"

  #spec.frameworks = 'FirebaseCore', 'FirebaseFirestore'


  #spec.pod_target_xcconfig = {
  #  'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/Firebase $(PODS_ROOT)/FirebaseCore/Frameworks $(PODS_ROOT)/FirebaseFirestore/Frameworks'
  #}

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
end
