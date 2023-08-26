//
//  ChatGPTService.swift
//  test_roulette
//
//  Created by Mac Pro on 26.08.2023.
//

import Foundation

class ChatGPTService {
    
    static let shared = ChatGPTService()
    
    private init() {}
    
    func fetchComment(for result: Int, completion: @escaping (String) -> Void) {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.setValue("Bearer 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", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let promt = result >= 0 ? "Напишите комментарий с сарказмом для человека, который только что выиграл небольшую сумму в рулетке" : "Напишите комментарий с сарказмом для человека, который только что проиграл небольшую сумму в рулетке"
        
        let requestData: [String: Any] = [
            "promt": promt,
            "max_tokens": 200,
            "model": "gpt-3.5-turbo",
            "temperature": 0.7,
            "top_p": 1,
            "frequency_penalty": 0.11
        ]

        let jsonData = try? JSONSerialization.data(withJSONObject: requestData)
        request.httpBody = jsonData
        
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
                          let text = choices.first?["text"] as? String {
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
