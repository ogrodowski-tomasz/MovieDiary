import OSLog

package extension Logger {
    func logResponseOnError(httpResponse: URLResponse, data: Data) {
      if let httpResponse = httpResponse as? HTTPURLResponse, httpResponse.statusCode > 299 {
        let error =
          "HTTP Response error: \(httpResponse.statusCode), response: \(httpResponse), data: \(String(data: data, encoding: .utf8) ?? "")"
        self.error("\(error)")
      }
    }
}
