#
# Be sure to run `pod lib lint IOTClientSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'IOTClientSDK'
  s.version          = '0.10.0'
  s.summary          = 'A library to wrap libcococlientsdk.'
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
  s.description      = <<-DESC
  Swift wrappers around libcococlientsdk.so, this wrapper can be used rapid
  develop of COCO applications on iOS platform.
  DESC
  
  s.homepage         = 'https://github.com/ashishbajaj99/cococlientsdk-swift'
  s.license          = { :type => 'Commercial', :file => 'LICENSE' }
  s.authors          = {  'rohan-elear' => 'rohansahay@elear.solutions',
    'shrinivas-elear' => 'shrinivasgutte@elear.solutions' }
  s.source           = {  :git => 'https://github.com/ashishbajaj99/cococlientsdk-swift.git',
    :tag => "v#{s.version.to_s}" }
  
  s.swift_version = '4.2'
  s.platform = [:ios, :macos]
  s.ios.deployment_target = '12.0'
  
  s.source_files = 'IOTClientSDK/**/*.swift'
  # s.vendored_libraries = 'Sources/**/*/libcococlientsdk_static.a'
  # s.static_framework = true
  
  # s.module_name = 'CIOTClientSDK'
  # s.module_map = 'CocoClientSDK/Sources/module.modulemap'
  s.preserve_paths = [
  'CIOTClientSDK/conanfile.py',
  'CIOTClientSDK/fetch-conan-libs.sh',
  'CIOTClientSDK/include/module.modulemap'
  ]
  
  s.pod_target_xcconfig = {
    'HEADER_SEARCH_PATHS' => [
    '$SRCROOT/CIOTClientSDK/include',
    '$PODS_TARGET_SRCROOT/CIOTClientSDK/include'],
    'SWIFT_INCLUDE_PATHS' => [
    '$SRCROOT/CIOTClientSDK/**',
    '$PODS_TARGET_SRCROOT/CIOTClientSDK'
    ],
    'LIBRARY_SEARCH_PATHS' => [
    '$SRCROOT/CIOTClientSDK/lib',
    '$PODS_TARGET_SRCROOT/CIOTClientSDK/lib'
    ]
  }
  
  s.script_phase = {
    :name => 'Fetch libraries',
    :script => 'sh $PODS_TARGET_SRCROOT/CIOTClientSDK/fetch-conan-libs.sh  --channel develop',
    :execution_position => :before_compile
  }
  
end
