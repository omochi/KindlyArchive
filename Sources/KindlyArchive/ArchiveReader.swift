import Foundation
import FilePathFramework

public class ArchiveReader {
    
    public init(path: FilePath) throws {
        guard let handle = FileHandle(forReadingAtPath: path.asString()) else {
            throw KindlyArchiveError(message: "open read file handle failed: \(path)")
        }
        self.handle = handle
        
        self.filePosition = 0
        self.bufferPosition = 0
        
        separator = "\n----\n"
        separatorData = separator.data(using: .utf8)!
    }
    
    deinit {
        handle.closeFile()
    }

    public func readHeader() throws -> Header {
        let separatorPosition = try findSeparator()
        
        handle.seek(toFileOffset: 0)
        let headerData = handle.readData(ofLength: Int(separatorPosition))
        let decoder = JSONDecoder()
        let header = try decoder.decode(Header.self, from: headerData)
        self.bodyPosition = separatorPosition + Int64(separatorData.count)
        return header
    }
    
    public func extractEntry(_ entry: Header.Entry, destination: FilePath) throws {
        let path = destination + FilePath(entry.path)
        switch entry.type {
        case .directory:
            try path.createDirectory(withIntermediates: true)
        case .file:
            try path.write(data: Data(), createDirectory: true)
            guard let writeHandle = FileHandle(forWritingAtPath: path.asString()) else {
                throw KindlyArchiveError(message: "open write file handle failed: \(path)")
            }
            try extractEntry(entry, writeHandle: writeHandle)
            writeHandle.closeFile()
        }
    }
    
    private func extractEntry(_ entry: Header.Entry, writeHandle: FileHandle) throws {
        handle.seek(toFileOffset: UInt64(bodyPosition! + entry.offset!))
        var rem = entry.size!
        while true {
            if rem == 0 {
                break
            }
            let chunkSize = min(rem, 8192)
            let chunk = handle.readData(ofLength: Int(chunkSize))
            if chunk.count == 0 {
                throw KindlyArchiveError(message: "read handle reached at end")
            }
            writeHandle.write(chunk)
            rem -= chunkSize
        }
    }
    
    private func findSeparator() throws -> Int64 {
        while true {
            let position = self.position
            
            guard let char = readByte() else {
                throw KindlyArchiveError(message: "invalid file format")
            }
            
            if char >= 0x80 {
                try skipMultibyteCharacter(headChar: char)
            } else if char == 0x0a {
                seek(to: position)
                if try checkSeparator() {
                    return position
                }
                seek(to: position + 1)
            }
        }
    }
    
    private func checkSeparator() throws -> Bool {
        for expectedByte in separatorData {
            guard let char = readByte() else {
                throw KindlyArchiveError(message: "invalid format")
            }
            if expectedByte != char {
                return false
            }
        }
        
        return true
    }
    
    private func skipMultibyteCharacter(headChar h: UInt8) throws {
        let len: Int
        
        if 0xC2 <= h && h <= 0xDF {
            len = 2
        } else if 0xE0 <= h && h <= 0xEF {
            len = 3
        } else if 0xF0 <= h && h <= 0xF7 {
            len = 4
        } else if 0xF8 <= h && h <= 0xFB {
            len = 5
        } else if 0xFC <= h && h <= 0xFD {
            len = 6
        } else {
            throw KindlyArchiveError(message: "invalid utf-8")
        }
        
        for _ in 0..<(len - 1) {
            guard let c = readByte() else {
                throw KindlyArchiveError(message: "invalid utf-8")
            }
            if 0x80 <= c && c <= 0xBF {
                continue
            }
            throw KindlyArchiveError(message: "invalid utf-8")
        }
    }
    
    private var position: Int64 {
        return filePosition + Int64(bufferPosition)
    }
    
    private func readByte() -> UInt8? {
        if bufferPosition == buffer.count {
            filePosition += Int64(bufferPosition)
            bufferPosition = 0
            buffer = handle.readData(ofLength: 2)
            if buffer.count == 0 {
                return nil
            }
        }
        let byte = buffer[bufferPosition]
        bufferPosition += 1
        return byte
    }

    private func seek(to position: Int64) {
        if filePosition <= position && position < filePosition + Int64(buffer.count) {
            bufferPosition = Int(position - filePosition)
            return
        }
        
        filePosition = position
        bufferPosition = 0
        handle.seek(toFileOffset: UInt64(filePosition))
        buffer = Data()
    }

    private let handle: FileHandle
    private var filePosition: Int64
    private var bufferPosition: Int
    private var buffer: Data = Data()
    
    private var bodyPosition: Int64?
    
    private let separator: String
    private let separatorData: Data
    
}
