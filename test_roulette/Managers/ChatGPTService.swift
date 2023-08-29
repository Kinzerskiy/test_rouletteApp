//
//  ChatGPTService.swift
//  test_roulette
//
//  Created by Mac Pro on 26.08.2023.
//

import Foundation

struct RequestData: Codable {
    var model: String
    var max_tokens: Int
    var messages: [Messages]
    
}
struct Messages: Codable {
    let role: String
    let content: String
}

class ChatGPTService {
    
    static let shared = ChatGPTService()
    
    private init() {}
    
    func fetchComment(for result: Int, completion: @escaping (String) -> Void) {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.setValue("Bearer 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", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let prompt = result >= 0 ? "Напишите комментарий с сарказмом для человека, который только что выиграл небольшую сумму в рулетке" : "Напишите комментарий с сарказмом для человека, который только что проиграл небольшую сумму в рулетке"
        
        let message = Messages(role: "user", content: prompt)
        let requestData = RequestData(model: "gpt-3.5-turbo-16k", max_tokens: 150, messages: [message])

        
        do {
            let jsonData = try JSONEncoder().encode(requestData)
            request.httpBody = jsonData
        } catch {
            print("Failed to encode JSON:", error)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                  print("HTTP Status Code: \(httpResponse.statusCode)")
              }
            
            guard let data = data, error == nil else {
                print("Error fetching comment:", error ?? "No data")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Received JSON: \(json)")
                    
                    if let choices = json["choices"] as? [[String: Any]],
                       let message = choices.first?["message"] as? [String: Any],
                       let text = message["content"] as? String {
                        DispatchQueue.main.async {
                            completion(text.trimmingCharacters(in: .whitespacesAndNewlines))
                        }
                    } else {
                        print("Unexpected format for 'choices'")
                    }
                } else {
                    print("JSON could not be cast to [String: Any]")
                }
            } catch let jsonError {
                print("Failed to serialize JSON:", jsonError)
            }
           }
           task.resume()
    }
}
