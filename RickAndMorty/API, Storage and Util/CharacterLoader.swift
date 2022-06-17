//
//  CharacterLoader.swift
//  RickAndMorty
//
//  Created by ZhengWu Pan on 17.06.2022.
//

import Foundation

class CharacterLoader {
    
    func loadCharacter(_ url: URL) async throws -> CharacterModel {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        guard let dict = try? JSONSerialization.jsonObject (with: data, options: .json5Allowed) as? [String: Any]
        else { throw URLError(.badServerResponse) }
        let name = dict["name"] as! String
        let imagePath = URL(string: (dict["image"] as? String)!)!
        let id = dict["id"] as? Int
        let status = dict["status"] as? String
        let species = dict["species"] as? String
        let gender = dict["gender"] as? String
        return  CharacterModel(id: id!, name: name, status: status!, species: species!,gender: gender!, image: imagePath)
    }
}
