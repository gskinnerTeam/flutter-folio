import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
    
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)
    
    initFlutterMethodChannel();
    setupWindow();
    super.awakeFromNib()
  }
    
    func setupWindow() {
        
    }
    
    func initFlutterMethodChannel() {
        let controller:FlutterViewController = self.contentViewController as! FlutterViewController;
        let channel = FlutterMethodChannel(
            name:"flutterfolio.com/io",
            binaryMessenger: controller.engine.binaryMessenger
        )
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            if call.method == "zoom" {
                self.zoomWindow(result: result)
            } else if (call.method == "getTitlebarHeight") {
                self.getTitlebarHeight(result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        })
    }
    
    func zoomWindow(result: FlutterResult) {
        self.zoom(self)
        result(true)
    }
    
    func getTitlebarHeight(result: FlutterResult) {
        if let windowFrameHeight = contentView?.frame.height {
            result(windowFrameHeight - contentLayoutRect.height)
        } else {
            result(0.0)
        }
    }
    
}
