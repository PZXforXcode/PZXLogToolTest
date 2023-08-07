# PZXLogToolTest
iOS项目日志查看方案Demo，用了CocoaDebug和CocoaLumberjack+LumberjackConsole 2种方案
## 1.[CocoaDebug](https://github.com/CocoaDebug/CocoaDebug)
可查看网络请求，Log日志，沙盒查看等

缺点：没有UI调试工具

```
        CocoaDebugSettings.shared.enableLogMonitoring = true


//MARK: - override Swift `print` method
public func print<T>(file: String = #file, function: String = #function, line: Int = #line, _ message: T, color: UIColor = .white) {
#if DEBUG
    //    Swift.print(message)
    //用DDlog是为了到处日志
    DDLogDebug(message)
    _SwiftLogHelper.shared.handleLog(file: file, function: function, line: line, message: message, color: color)
#endif
}

```



## 2.[CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack)+[LumberjackConsole](https://github.com/PTEz/LumberjackConsole)

查看Log日志，通过LumberjackConsole展示

```
    ///[CocoaLumberjack]+[LumberjackConsole]的日志方案
    fileprivate func CocoaLumberjackFun() {
        // Do any additional setup after loading the view.
        DDLog.add(DDOSLogger.sharedInstance) // Uses os_log
        
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
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
```
