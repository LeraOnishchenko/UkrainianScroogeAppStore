import Foundation

struct ApiSesson {
    var networkService = Network()
    
    
    func retrieveImageData(url: URL) async throws -> Data? {
        do {
            let data = try await self.networkService.perform(.get, url)
            return data
        } catch {
            print(error)
        }
        return nil
    }
}

