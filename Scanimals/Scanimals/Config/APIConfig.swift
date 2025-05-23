import Foundation

enum APIConfig {
    private static let config: [String: String] = {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: String] else {
            fatalError("Config.plist not found or invalid")
        }
        return dict
    }()
    
    static var geminiKey: String {
        guard let key = config["GEMINI_API_KEY"] else {
            fatalError("GEMINI_API_KEY not found in Config.plist")
        }
        return key
    }
} 