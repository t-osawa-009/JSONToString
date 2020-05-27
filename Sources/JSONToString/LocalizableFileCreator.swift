import Foundation
import Files

enum Format: String {
    case xml
    case strings
}

enum Sort: String {
    case asc
    case desc
}

enum CreatorError: Error {
    case invalidFormat
}

struct LocalizableFileCreatorForXML: FileCreatable {
    private let json: [[String: Any]]
    private let key: String
    private let valuekey: String
    private let outputPath: String
    private let sort: Sort?
    init(json: [[String: Any]], key: String, valuekey: String, outputPath: String, sort: Sort?) {
        self.json = json
        self.key = key
        self.valuekey = valuekey
        self.outputPath = outputPath
        self.sort = sort
    }
    
    func write() throws {
        let urlPath = URL(fileURLWithPath: outputPath)
        let path = urlPath.deletingLastPathComponent().absoluteString
        let _path = path.replacingOccurrences(of: "file://", with: "")
        let folder = try Folder(path: _path)
        let fileName = urlPath.lastPathComponent
        let file = try folder.createFileIfNeeded(at: fileName.replacingOccurrences(of: "file://", with: ""))
        let pathExtension = urlPath.pathExtension
        guard pathExtension == "xml" else {
            print("format is not xml")
            throw CreatorError.invalidFormat
        }
        var strings = json.compactMap({ value -> String? in
            if let _key = value[key] as? String,
                !_key.isEmpty,
                let _value = value[valuekey] as? String,
                !_value.isEmpty {
                return """
                <string name="\(_key)">"\(_value.replacingOccurrences(of: "\"", with: "\\\""))"</string>
                """
            } else {
                return nil
            }
        })
        
        if let _sort = sort {
            strings.sort(by: { value1, value2 in
                switch _sort {
                case .asc:
                    return value1 < value2
                case .desc:
                    return value1 > value2
                }
            })
        }

        
        strings.insert("""
<?xml version="1.0" encoding="utf-8"?>
<resources>
""",
                       at: 0)
        strings.append("</resources>")
        
        let results = strings.joined(separator: "\n")
        let oldData = try file.readAsString()
        if oldData == results {
            print("Not writing the file as content is unchanged")
        } else {
            try file.write(results)
        }
    }
}

struct LocalizableFileCreatorForStrings: FileCreatable {
    private var json: [[String: Any]]
    private let key: String
    private let valuekey: String
    private let outputPath: String
    private let sort: Sort?
    
    init(json: [[String: Any]], key: String, valuekey: String, outputPath: String, sort: Sort?) {
        self.json = json
        self.key = key
        self.valuekey = valuekey
        self.outputPath = outputPath
        self.sort = sort
    }
    
    func write() throws {
        let urlPath = URL(fileURLWithPath: outputPath)
        let path = urlPath.deletingLastPathComponent().absoluteString
        let _path = path.replacingOccurrences(of: "file://", with: "")
        let folder = try Folder(path: _path)
        let fileName = urlPath.lastPathComponent
        let file = try folder.createFileIfNeeded(at: fileName.replacingOccurrences(of: "file://", with: ""))
        let pathExtension = urlPath.pathExtension
        guard pathExtension == "strings" else {
            print("format is not strings")
            throw CreatorError.invalidFormat
        }
        
        var strings = json.compactMap({ value -> String? in
            if let _key = value[key] as? String,
                !_key.isEmpty,
                let _value = value[valuekey] as? String,
                !_value.isEmpty {
                let result = _value
                    .replacingOccurrences(of: "\"", with: "\\\"")
                
                let result2 = result
                    .replacingOccurrences(of: "%[0-9]\\$", with: "%", options: .regularExpression, range: result.range(of: result))
                
                let result3 = result2
                    .replacingOccurrences(of: "%d", with: "%@")
                
                let result4 = result3
                    .replacingOccurrences(of: "%s", with: "%@")
                
                return """
                "\(_key)" = "\(result4)";
                """
            } else {
                return nil
            }
        })
        
        if let _sort = sort {
            strings.sort(by: { value1, value2 in
                switch _sort {
                case .asc:
                    return value1 < value2
                case .desc:
                    return value1 > value2
                }
            })
        }
        strings.append("\n")
        let results = strings.joined(separator: "\n")
        if try file.readAsString() == results {
            print("Not writing the file as content is unchanged")
        } else {
            try file.write(results)
        }
    }
}
