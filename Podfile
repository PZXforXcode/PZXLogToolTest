# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

target 'PZXLogToolTest' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for CocoaLumberjackLogTest
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        xcconfig_path = config.base_configuration_reference.real_path
        xcconfig = File.read(xcconfig_path)
        xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
        File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
      end
    end

    # https://github.com/CocoaPods/CocoaPods/issues/7314
    fix_deployment_target(installer)
  end

  def fix_deployment_target(pod_installer)
    return unless pod_installer
    puts "Make the pods deployment target version the same as our target"
    
    project = pod_installer.pods_project
    deployment_map = {}

    project.build_configurations.each do |config|
      deployment_map[config.name] = config.build_settings['IPHONEOS_DEPLOYMENT_TARGET']
    end

    project.targets.each do |target|
      puts "  #{target.name}"
      
      target.build_configurations.each do |config|
        old_target = config.build_settings['IPHONEOS_DEPLOYMENT_TARGET']
        new_target = deployment_map[config.name]

        next if old_target.to_f >= new_target.to_f

        puts "    #{config.name} deployment target: #{old_target} => #{new_target}"
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
  end
  
  
	  	pod 'SnapKit'
		pod 'FLEX', :configurations => ['Debug']
		pod 'CocoaLumberjack/Swift'
    pod 'LumberjackConsole', :configurations => ['Debug']
    pod 'CocoaDebug', :configurations => ['Debug']

end
