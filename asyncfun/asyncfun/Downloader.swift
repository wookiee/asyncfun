
import Foundation

// In here we play with the idea of the `continuation` api
// for calling completion-handler-based methods
// from async contexts while still being able to await their results

class Downloader {
    
    func buttonTapped() {
        async {
            let url = URL(string: "https://bignerdranch.com")!
            let data = try? await self.downloadData(from: url)
            print("we got \(data?.count ?? 0) bytes")
        }
    }
    
    func downloadData(from url: URL) async throws -> Data? {
        return try await withUnsafeThrowingContinuation { continuation in
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data, (response as! HTTPURLResponse).statusCode == 200 {
                    continuation.resume(returning: data)
                } else {
                    continuation.resume(throwing: error!)
                }
            }
            task.resume()
        }
    }
    
}
