import SwiftUI

struct ContentView: View {
    @State private var keyChecked: Bool = false
    @State private var requestToken: TokenResponse?
    
    @State private var username: String = "tomaszinio"
    @State private var password: String = "byhti0-jIsfuh-bapsam"
    
    @State private var sessionid: String?
    
    var body: some View {
        NavigationStack {
            List {
                Section("Api status") {
                    LabeledContent {
                        Text(keyChecked ? "✅" : "⛔️")
                    } label: {
                        Button("Check API status", action: checkApiKey)
                            .disabled(keyChecked)
                    }
                }
                
                Section("Request Token") {
                    LabeledContent {
                        Text(requestToken?.requestToken ?? "Empty")
                    } label: {
                        Button("Fetch request token", action: getRequestToken)
                            .disabled(requestToken != nil)
                    }
                }
                
                Section("Session Id") {
                    TextField("Username", text: $username)
                    SecureField("Password", text: $password)
                    LabeledContent {
                        Text(sessionid ?? "Empty")
                    } label: {
                        Button("Fetch session id", action: authRequestTokenAndGetSessionId)
                            .disabled(sessionid != nil)
                    }
                }
            }
        }
        .onChange(of: sessionid) { oldValue, newValue in
            print("DEBUG: NEW SESSION ID \(newValue ?? "-")")
        }
    }
    
    private func checkApiKey() {
        Task {
            guard let url = URL(string: "https://api.themoviedb.org/3/authentication") else { fatalError("") }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(AppKey.appKey)", forHTTPHeaderField: "Authorization")
            
            do {
                let (_, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Error fetching data")
                    return
                }
                print("DEBUG: Success!")
                keyChecked = true
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func getRequestToken() {
        Task {
            guard let url = URL(string: "https://api.themoviedb.org/3/authentication/token/new") else { fatalError("") }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(AppKey.appKey)", forHTTPHeaderField: "Authorization")
            
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Error fetching data")
                    return
                }
                let value = try TokenResponse.decoder.decode(TokenResponse.self, from: data)
                self.requestToken = value
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func authRequestTokenAndGetSessionId() {
        Task {
            guard let requestToken = requestToken?.requestToken else { return }
            let parameters = [
                "username": username,
                "password": password,
                "request_token": requestToken
            ] as [String : Any?]

            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])

            guard let url = URL(string: "https://api.themoviedb.org/3/authentication/token/validate_with_login") else { fatalError("") }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("Bearer \(AppKey.appKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = postData
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Error authentication request token ")
                    return
                }
                try await getSessionId()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func getSessionId() async throws {
        guard let requestToken = requestToken?.requestToken else { return }

        let parameters = [
            "request_token": requestToken
        ] as [String : Any?]

        let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])

        guard let url = URL(string: "https://api.themoviedb.org/3/authentication/session/new") else { fatalError("") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(AppKey.appKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = postData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error getting session id")
                return
            }
            let value = try SessionResponse.decoder.decode(SessionResponse.self, from: data)
            self.sessionid = value.sessionId

        } catch {
            print(error.localizedDescription)
        }

    }
}

struct ChildView: View {
    let sessionId: String
    
    var body: some View {
        VStack {
            Text("Session ID: \(sessionId)")
        }
    }
}

struct TokenResponse: Codable {
    let success: Bool
    let expiresAt: String
    let requestToken: String
    
    static var decoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
//        jsonDecoder.dateDecodingStrategy = .iso8601
        return jsonDecoder
    }
}

struct SessionResponse: Codable {
    let success: Bool
    let sessionId: String
    
    static var decoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
//        jsonDecoder.dateDecodingStrategy = .iso8601
        return jsonDecoder
    }
}

#Preview {
    ContentView()
}
