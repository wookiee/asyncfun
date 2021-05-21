
import Foundation

// @MainActor
class NewMosaicMaker {
                                                          // Stubs, just compile pls
    func prepareImageFileList() async -> [URL]            { [URL(fileURLWithPath: "foo.bar")] }
    func loadImage(at url: URL) async -> Data             { Data() }
    func combineImages(_ files: [Data]) async -> Data     { Data() }
    @MainActor func display(image: Data) async            { imageToDisplay = image }
    
    @MainActor var imageToDisplay: Data? = nil {
        didSet {
            dispatchPrecondition(condition: .onQueue(.main))
            print("New image set!")
        }
    }
        
    func buttonTapped() {
        async(priority: .utility) { // `async` function will be renamed as a `Task` initializer
            let image = await self.makeMosaicAltVersion()
            await self.display(image: image)
        }
    }
    
    /// Uses asyncUnorderedMap in `Array+Concurrency.swift`
    func makeMosaicAltVersion() async -> Data {
        let urls = await prepareImageFileList()
        let gatheredImages = await urls.concurrentUnorderedMap { url in
            return await self.loadImage(at: url)
        }
        let finalImage = await combineImages(gatheredImages)
        return finalImage
    }
    
    /// Original version that does the work of the same method in MosaicMaker
    func makeMosaic() async -> Data {
        let urls = await prepareImageFileList()
        let images: [Data] = await withTaskGroup(of: Data.self) { taskGroup in
            var images = [Data]()
            
            for url in urls {
                taskGroup.spawn {
                    return await self.loadImage(at: url)
                }
            }
        
            for await image in taskGroup {
                images.append(image)
            }
            
            return images
        }
        let mosaic = await combineImages(images)
        return mosaic
    }
}
