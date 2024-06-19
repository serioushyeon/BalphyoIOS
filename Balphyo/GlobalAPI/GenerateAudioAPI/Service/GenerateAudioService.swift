//
//  GenerateAudioService.swift
//  Balphyo
//
//  Created by jin on 6/19/24.
//

import Foundation

protocol GenerateAudioServiceProtocol {
    func generateAudio(bodyDTO: GenerateAudioRequest, completion: @escaping (NetworkResult<GenerateAudioResponse>) -> Void)
}

final class GenerateAudioService: APIRequestLoader<GenerateAudioTarget>, GenerateAudioServiceProtocol {
    func generateAudio(bodyDTO: GenerateAudioRequest, completion: @escaping (NetworkResult<GenerateAudioResponse>) -> Void) {
        fetchData(target: .generateAudio(bodyDTO), responseData: GenerateAudioResponse.self, completion: completion)
    }

}
