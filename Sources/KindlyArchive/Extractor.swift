import Foundation

public class Extractor {
    public init() {}
    
    public func extract(archivePath: String, destination: String) throws {
        let archivePath = Path(archivePath)
        let destination = Path(destination)
        
        let reader = try ArchiveReader(path: archivePath)
        let header = try reader.readHeader()
        for entry in header.entries {
            try reader.extractEntry(entry, destination: destination)
        }
    }
}
