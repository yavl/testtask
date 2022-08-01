//
//  ImageLoader.swift
//  CellTetris
//
//  Created by Vladislav Nikolaev on 01.08.2022.
//

import Foundation
import UIKit

fileprivate let imageCacheFilename = "imageCache"

/// Image loader with naive caching
class ImageLoader {
    // could be further improved, but I think memory consumption/performance is negligible here
    private static var cachedImages: [String: UIImage] = [:]
    private static var cachedImagesData: [String: Data] = [:]
    private static var downloadingUrls: Set<String> = []
    
    // `func loadImage`'s body is almost copy/paste, to be fair (source: https://stackoverflow.com/a/39813761)
    /// Load image asynchronously from the given url
    /// - Parameter completion: A closure that is called on success. Note: completion is already called in main queue, no need for DispatchQueue.main.async wrap
    static func loadImage(from url: String, completion: @escaping (UIImage) -> Void) {
        guard !downloadingUrls.contains(url) else { return }
        if let image = cachedImages[url] {
            DispatchQueue.main.async {
                completion(image)
            }
            return
        }
        guard let imageUrl = URL(string: url) else { return }
        
        downloadingUrls.insert(url)

        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        let session = URLSession(configuration: config)
        let downloadPicTask = session.dataTask(with: imageUrl) { data, response, error in
            defer {
                downloadingUrls.remove(url)
            }
            if let e = error {
                print("Error downloading picture: \(e)")
                return
            } else {
                guard let res = response as? HTTPURLResponse else {
                    print("Couldn't get response code for some reason")
                    return
                }
                print("Downloaded picture with response code \(res.statusCode)")
                if let imageData = data {
                    DispatchQueue.main.async {
                        guard let image = UIImage(data: imageData) else { return }
                        cachedImages[url] = image
                        cachedImagesData[url] = imageData
                        completion(image)
                    }
                } else {
                    print("Couldn't get image: Image is nil")
                }
            }
        }

        downloadPicTask.resume()
    }
    
    static func saveCacheToFilesystem() {
        do {
            try cachedImagesData.saveToDisk(on: .cachesDirectory, withName: imageCacheFilename)
        } catch {
            print("Failed to save imageCache - no error handling here")
        }
    }
    
    static func readToCacheFromFilesystem() {
        cachedImagesData = Dictionary.load(fromFileName: imageCacheFilename) ?? [:]
        for each in cachedImagesData {
            cachedImages[each.key] = UIImage(data: each.value)
            print("file: \(each.key)")
        }
    }
    
    static func clearCache() {
        cachedImages = [:]
        cachedImagesData = [:]
        let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let filename = path.appendingPathComponent(imageCacheFilename)
        do {
            try FileManager.default.removeItem(at: filename)
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
}

// copy/paste (source: https://stackoverflow.com/a/66389997)
extension Dictionary where Key: Codable, Value: Codable {
    static func load(fromFileName fileName: String, using fileManager: FileManager = .default) -> [Key: Value]? {
        let fileURL = Self.getDocumentsURL(on: .cachesDirectory, withName: fileName, using: fileManager)
        guard let data = fileManager.contents(atPath: fileURL.path) else { return nil }
        do {
            return try JSONDecoder().decode([Key: Value].self, from: data)
        } catch(let error) {
            print(error)
            return nil
        }
    }

    func saveToDisk(on directory: FileManager.SearchPathDirectory,
                    withName name: String,
                    using fileManager: FileManager = .default) throws {

        let fileURL = Self.getDocumentsURL(on: .cachesDirectory, withName: name, using: fileManager)
        let data = try JSONEncoder().encode(self)
        try data.write(to: fileURL)
    }

    private static func getDocumentsURL(on directory: FileManager.SearchPathDirectory,
                                 withName name: String,
                                 using fileManager: FileManager) -> URL {

        let folderURLs = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        let fileURL = folderURLs[0].appendingPathComponent(name)
        return fileURL
    }
}
