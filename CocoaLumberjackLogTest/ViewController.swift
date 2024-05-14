//
//  ViewController.swift
//  CocoaLumberjackLogTest
//
//  Created by 彭祖鑫 on 2023/8/7.
//

import UIKit
import FLEX
import CocoaLumberjack
import LumberjackConsole
import CocoaDebug

class ViewController: UIViewController {

    var logFilePath : String = "";

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CocoaLumberjackFun()

        
        let button = UIButton(type: .custom)
        button.setTitle("点击", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.frame = CGRect(x: 10, y: 0, width: 66, height: 40)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.addTarget(self, action: #selector(rightButtonPressed(_:)), for: .touchUpInside)
        
        // 设置按钮的宽度和高度约束
        button.widthAnchor.constraint(equalToConstant: 66).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let rightButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = rightButton
        

    }
    
    
    //通过分享导出日志
    @objc func rightButtonPressed(_ sender: UIButton) {
         // 在这里实现按钮点击事件的处理逻辑
        
        // 1. 获取文件的路径
        let filepath = self.logFilePath
                
                // 2. 将文件路径转换为URL
            let fileURL = URL(fileURLWithPath: filepath)
                // 3. 创建UIActivityViewController，并将文件URL作为活动项传递给它
                let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
                // 4. 展示UIActivityViewController
                self.present(activityViewController, animated: true, completion: nil)
        
        
     }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Swift
//        FLEXManager.shared.showExplorer()
//        DDLogDebug("Debug")
        
        print("CocoDebug 测试 点击了 在CocoDebug控制台可以看到！")

    }
    
    
    ///[CocoaLumberjack]+[LumberjackConsole]的日志方案
    fileprivate func CocoaLumberjackFun() {
        // Do any additional setup after loading the view.
        let customFormatter = MyCustomLogFormatter()
        DDLog.add(DDOSLogger.sharedInstance) // Uses os_log
        DDOSLogger.sharedInstance.logFormatter = customFormatter

        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        fileLogger.logFormatter = customFormatter
        DDLog.add(fileLogger)
        
        //logs文件夹路径
        DDLogInfo("logsDirectory=\(fileLogger.logFileManager.logsDirectory)");
        DDLogVerbose("Verbose")
        DDLogDebug("Debug")
        DDLogInfo("Info")
        DDLogWarn("Warn")
        DDLogError("Error")
        
        let logFileManager = fileLogger.logFileManager
        let logFilePaths = logFileManager.sortedLogFilePaths
        
        if let logFilePath = logFilePaths.last {
            
            self.logFilePath = logFilePath
            print("Log file path: \(logFilePath)")
        }
        
        LumberjackConsole.PTEDashboard.shared().show()
    }


}


class MyCustomLogFormatter: NSObject, DDLogFormatter {
    
    func format(message logMessage: DDLogMessage) -> String? {
        let logLevel: String
        switch logMessage.flag {
        case .verbose: logLevel = "VERBOSE"
        case .debug: logLevel = "DEBUG"
        case .info: logLevel = "INFO"
        case .warning: logLevel = "WARN"
        case .error: logLevel = "ERROR"
        default: logLevel = "UNKNOWN"
        }
        
        let file = logMessage.file as NSString
        let fileName = file.lastPathComponent
        let lineNumber = logMessage.line
        
        return "\(logLevel) - [\(fileName):\(lineNumber)] \(logMessage.message)"
    }
}

