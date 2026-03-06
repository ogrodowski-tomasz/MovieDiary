import OSLog

extension Logger {
    
    public init(category: String) {
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? "missing bundle id"
        self.init(subsystem: bundleIdentifier, category: category)
    }
    
    public func logResponseOnError(httpResponse: URLResponse, data: Data) {
      if let httpResponse = httpResponse as? HTTPURLResponse, httpResponse.statusCode > 299 {
        let error =
          "HTTP Response error: \(httpResponse.statusCode), response: \(httpResponse), data: \(String(data: data, encoding: .utf8) ?? "")"
        self.error("\(error)")
      }
    }
    
}
