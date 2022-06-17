import Foundation

enum Level: Int {
    case info
    case debug
    case warning
    case error
    case fatal
}

protocol LoggerProtocol {
    func log(level: Level, message: String)
}

protocol Writer {
    func write(message: String)
}

final class ConsoleWriteer: Writer {
    func write(message: String) {
        print(message)
    }
}

final class FileWriter: Writer {
    var paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    func write(message: String) {
        
        var filename = paths.first
        filename?.appendPathComponent("log.txt")
        if let handle = try? FileHandle(forWritingTo: filename!) {
            handle.seekToEndOfFile() // moving pointer to the end
            handle.write((message + "\n").data(using: .utf8)!) // adding content
            handle.closeFile() // closing the file
        }
    }
}
// TODO: Console
// TODO: File

final class AppLogger: LoggerProtocol {
    private static let queue = DispatchQueue(label: "")
    
    private let writers: [Writer]
    private let minLevel: Level
    
    init(writers: [Writer], minLevel: Level) {
        self.writers = writers
        self.minLevel = minLevel
    }
    
    func log(level: Level, message: String) {
        // TODO: implement
        for writer in writers {
            AppLogger.queue.async {
                writer.write(message: message)
            }
        }
    }
}


