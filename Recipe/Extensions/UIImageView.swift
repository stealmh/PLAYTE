//
//  UIImageView.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/15.
//

import UIKit

extension UIImageView {
    func loadImage(from urlString: String) {
        guard let imageUrl = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error loading image: \(error)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}
