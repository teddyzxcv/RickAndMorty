//
//  ImageLoader.swift
//  RickAndMorty
//
//  Created by ZhengWu Pan on 17.05.2022.
//

import Foundation
import UIKit
import Combine

class ImageLoader {
    func getImage(from url: URL) async throws -> UIImage? {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return UIImage (data: data)
    }
    
    static func getImageURLbyID(_ id: Int) -> URL? {
        return URL(string:"https://rickandmortyapi.com/api/character/avatar/\(id).jpeg")
    }
    
    static func getCharacterURLbyID(_ id: Int) -> URL? {
        return URL(string: "https://rickandmortyapi.com/api/character/\(id)"  )
    }
    
    
    struct Model {
        let name: AnyPublisher<String, Error>
        let url: AnyPublisher<URL, Error>
        let statusModel: AnyPublisher<InfoCell.Model, Error>
    }
}
