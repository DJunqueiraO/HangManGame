//
//  SessionManager.swift
//  hangman
//
//  Created by Josicleison on 05/09/22.
//

import UIKit

class SessionManager {
    
    func APIFullRequest(completion: @escaping (AdvicesSlip) -> Void) {
        
        let url = URL(string: "https://api.adviceslip.com/advice")!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
        
            if let error = error {
                print("Error with fetching films: \(error)")
                return
            }
          
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode)
            else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                return
            }

            if let data = data, let advice = try? JSONDecoder().decode(AdvicesSlip.self, from: data) {
              
                DispatchQueue.main.async {
                    
                    completion(advice)
                }
            }
        }
        
        task.resume()
    }
}
