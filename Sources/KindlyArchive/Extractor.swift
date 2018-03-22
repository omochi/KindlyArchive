import Foundation
import FilePathFramework

public class Extractor {
    public init() {}
    
    public func extract(archivePath: String, destination: String) throws {
        let archivePath = FilePath(archivePath)
        let destination = FilePath(destination)
        
        let reader = try ArchiveReader(path: archivePath)
        let header = try reader.readHeader()
        for entry in header.entries {
            try reader.extractEntry(entry, destination: destination)
        }
    }
}
