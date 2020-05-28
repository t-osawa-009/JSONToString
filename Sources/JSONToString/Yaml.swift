import Foundation
import Yams
import Files

struct Yaml {
    let jsons: [[String: Any]]
    init(path: String) throws {
        let folder = try Folder(path: path)
        let file = try folder.file(named: ".JSONToString.yml")
        let string = try file.readAsString()
        var items = try Yams.load_all(yaml: string)
        var _result: [[String: Any]] = []
        while let item = items.next() {
            if let _item = item as? [String: Any] {
                _result.append(_item)
            }
        }
        self.jsons = _result
    }
}

struct YamlStringsParser {
    struct Output {
        let output: String
        let format: Format
        let key: String
        let valuekey: String
        let sort: Sort?
    }
    
    enum Format: String {
        case xml
        case strings
    }
    
    var outputs: [Output]
    init?(jsons: [[String: Any]]) {
        var _outputs: [Output] = []
        jsons.forEach { (json) in
            guard let outputs = json["outputs"] as? [[String: Any]] else {
                return
            }
            outputs.forEach { (dic) in
                guard let output = dic["output"] as? String else {
                    return
                }
                guard let format = Format(rawValue: dic["format"] as? String ?? "xml") else {
                    return
                }
                
                guard let key = dic["key"] as? String else {
                    return
                }
                
                guard let valuekey = dic["value_key"] as? String else {
                    return
                }
                
                let sortValue = dic["sort"] as? String
                let sort = Sort(rawValue: sortValue ?? "")
                let value = Output(output: output,
                                   format: format,
                                   key: key,
                                   valuekey: valuekey,
                                   sort: sort)
                _outputs.append(value)
            }
        }
        if _outputs.isEmpty {
            return nil
        } else {
            self.outputs = _outputs
        }
    }
}
