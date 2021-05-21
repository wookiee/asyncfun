
import Foundation

/*
We need a class that can:
 - load all of the images in a particular directory into memory (in the background)
 - stitch those images into a tile mosaic (in the background)
 - display the final mosaic to the user (on the main thread)
 */

class MosaicMaker {
                                                    // stubs, just compile please
    func prepareImageFileList() -> [URL]            { [URL(fileURLWithPath: "foo.bar")] }
    func loadImage(at url: URL) -> Data             { Data() }
    func combineImages(_ files: [Data]) -> Data     { Data() }
    func display(image: Data)                       { imageToDisplay = image }
    
    var imageToDisplay: Data? = nil {
        didSet {
            dispatchPrecondition(condition: .onQueue(.main))
            print("New image set!")
        }
    }
    
    private let lockQueue = DispatchQueue(label: "lockQueue")
    
    private var _images = [Data]()
    var images: [Data] {
        get { lockQueue.sync { _images } }
        set { lockQueue.sync { _images = newValue } }
    }
    
    func buttonTapped() {
        makeMosaic { mosaic in
            self.display(image: mosaic)
        }
    }
    
    let dispatchGroup = DispatchGroup()

    func makeMosaic(completion: @escaping (Data) -> Void) {
        DispatchQueue.global().async {
            let urls = self.prepareImageFileList()
            for url in urls {
                DispatchQueue.global().async(group: self.dispatchGroup) {
                    let image = self.loadImage(at: url)
                    self.images.append(image)
                }
            }
            self.dispatchGroup.notify(queue: .global()) {
                let finalImage = self.combineImages(self.images)
                DispatchQueue.main.async {
                    completion(finalImage)
                }
            }
        }
    }
}
