//
//  SparkStorage.swift
//  FirebaseDB
//
//  Created by Alex Nagy on 27.11.2020.
//

import FirebaseStorage
import FirebaseFirestore

struct SparkStorage {
    
    static func save(image: UIImage, folderPath: String, compressionQuality: CGFloat, completion: @escaping (Result<URL, Error>) -> ()) {
        
        guard let imageData = image.jpegData(compressionQuality: compressionQuality) else {
            completion(.failure(SparkStorageError.noImageAvailable))
            return
        }
        
        let imageFileName = UUID().uuidString
        
        let imageReference = SparkFirebaseRootReference.storage
            .child(folderPath)
            .child(imageFileName)
        
        imageReference.putData(imageData, metadata: nil) { (metadata, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            
            imageReference.downloadURL { (url, err) in
                if let err = err {
                    completion(.failure(err))
                    return
                }
                guard let url = url else {
                    completion(.failure(SparkStorageError.noUrl))
                    return
                }
                completion(.success(url))
            }
            
        }
    }
    
    static func deleteImage(at url: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        let imageReference = SparkFirebaseRootReference.baseStorage.reference(forURL: url)
        imageReference.delete { (err) in
            if let err = err {
                print(err._code)
                guard err._code == StorageErrorCode.objectNotFound.rawValue else {
                    completion(.failure(err))
                    return
                }
                completion(.success(false))
                return
            }
            completion(.success(true))
        }
    }
    
    static func handleImageChange(newImage: UIImage, folderPath: String, compressionQuality: CGFloat, oldImageUrl: String, completion: @escaping (Result<URL, Error>) -> ()) {
        guard oldImageUrl.contains("https") else {
            print("Old image url does not contain https. No image to delete")
            self.save(image: newImage,
                      folderPath: folderPath,
                      compressionQuality: compressionQuality) { (result) in
                        completion(result)
            }
            return
        }
        deleteImage(at: oldImageUrl) { (result) in
            switch result {
            case .success(let objectFound):
                print("Object to be deleted was found: \(objectFound)")
                self.save(image: newImage,
                          folderPath: folderPath,
                          compressionQuality: compressionQuality) { (result) in
                            completion(result)
                }
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
}

