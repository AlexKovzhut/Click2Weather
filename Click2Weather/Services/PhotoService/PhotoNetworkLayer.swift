//
//  PhotoNetworkLayer.swift
//  Click2Weather
//
//  Created by Alexander Kovzhut on 02.01.2022.
//

import UIKit

enum PhotoServiceError: Error {
    case server, parsing
}

class PhotoNetworkLayer {
    static let shared = PhotoNetworkLayer()
    
    func fetchData(completion: @escaping ((Result<[PhotoData], Error>) -> Void)) {
        let url = URL(string: "https://api.unsplash.com/photos/random?client_id=F8qFf42dxGvig_oG30JrkfG9XqFct5qeAm6Nvv_D6KY&query=London&count=1&orientation=portrait")!
        
        let task = URLSession.shared.dataTask(with: url) { data, responce, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
            }
            
            guard let data = data else { return }
            
            guard let httpResponce = responce as? HTTPURLResponse, (200...299).contains(httpResponce.statusCode) else {
                completion(Result.failure(PhotoServiceError.server))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let result = try decoder.decode([PhotoData].self, from: data)
                DispatchQueue.main.async {
                    completion(Result.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(Result.failure(PhotoServiceError.parsing))
                }
            }
        }
        task.resume()
    }
}
