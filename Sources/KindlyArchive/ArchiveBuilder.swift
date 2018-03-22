import Foundation
import FilePathFramework

public class ArchiveBuilder {
    public let baseDir: FilePath
    public let paths: [FilePath]
    public let destination: FilePath
    
    public init(baseDir: FilePath, paths: [FilePath], destination: FilePath) {
        self.baseDir = baseDir
        self.paths = paths
        self.destination = destination
    }
    
    public func build() throws {
        if destination.exists {
            throw KindlyArchiveError(message: "destination is already exists: path=\(destination)")
        }
        
        if !baseDir.isDirectory {
            throw KindlyArchiveError(message: "baseDir is not directory. baseDir=\(baseDir)")
        }
        
        var entries: [Entry] = []
        var index: Int = 0
        for path in paths {
            let checkPath = path.normalized()
            guard let checkHead = checkPath.components.first else {
                throw KindlyArchiveError(message: "invalid path: \(path)")
            }
            if checkHead == FilePath("..") {
                throw KindlyArchiveError(message: "invalid path: \(path)")
            }
            
            let realPath = baseDir + path
            
            if realPath.isSymbolicLink {
                // TODO: symlink archive feature
                continue
            }
            
            if !realPath.exists {
                throw KindlyArchiveError(message: "path not exists: \(realPath)")
            }
            
            let entry: Entry
            
            if realPath.isDirectory {
                entry = .directory(index: index,
                                   path: path,
                                   realPath: realPath)
            } else {
                let attrs = try realPath.attributes()
                guard let size = (attrs[FileAttributeKey.size] as? NSNumber)?.int64Value else {
                    throw KindlyArchiveError(message: "getting file size failed: \(realPath)")
                }
                entry = .file(index: index,
                              path: path,
                              realPath: realPath,
                              size: size)
            }
            entries.append(entry)
            index += 1
        }
        
        let separator = "\n----\n"
        let separatorData = separator.data(using: .utf8)!
        
        var offset: Int64 = 0
        let fileEntries = entries.filter { $0.type == .file }
        for entry in fileEntries {
            var entry = entry
            
            let banner = entry.path.asString() + "\n"
            let bannerData = banner.data(using: .utf8)!
            entry.banner = bannerData
            offset += Int64(bannerData.count)
            
            entry.offset = offset
            offset += entry.size!
            offset += Int64(separatorData.count)
            
            entries[entry.index] = entry
        }
        
        let header = makeHeader(entries: entries)
        
        try destination.write(data: Data())
        let writeHandle = try destination.openWritingHandle()
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let headerJSON: Data = try encoder.encode(header)
        
        writeHandle.write(headerJSON)
        writeHandle.write(separatorData)
        
        for entry in entries {
            if entry.type == .file {
                try writeEntry(entry, writeHandle: writeHandle)
                writeHandle.write(separatorData)
            }
        }
    }
    
    private struct Entry {
        public var index: Int
        public var path: FilePath
        public var realPath: FilePath
        public var type: Header.Entry.EntryType
        public var size: Int64? = nil
        public var offset: Int64? = nil
        public var banner: Data? = nil
        
        public init(index: Int,
                    path: FilePath,
                    realPath: FilePath,
                    type: Header.Entry.EntryType)
        {
            self.index = index
            self.path = path
            self.realPath = realPath
            self.type = type
        }
        
        public static func directory(index: Int,
                                     path: FilePath,
                                     realPath: FilePath) -> Entry
        {
            return Entry(index: index, path: path, realPath: realPath, type: .directory)
        }
        
        public static func file(index: Int,
                                path: FilePath,
                                realPath: FilePath,
                                size: Int64) -> Entry {
            var entry = Entry(index: index, path: path, realPath: realPath, type: .file)
            entry.size = size
            return entry
        }
    }
    
    private func makeHeader(entries: [Entry]) -> Header {
        let entries = entries.map { entry in
            Header.Entry(path: entry.path.asString(),
                         type: entry.type,
                         size: entry.size,
                         offset: entry.offset)
        }
        return Header(entries: entries)
    }
    
    private func writeEntry(_ entry: Entry, writeHandle: FileHandle) throws {
        writeHandle.write(entry.banner!)
        
        let readHandle = try entry.realPath.openReadingHandle()
        
        while true {
            let chunk = readHandle.readData(ofLength: 8192)
            if chunk.count == 0 {
                break
            }
            
            writeHandle.write(chunk)
        }
    }
    
}
