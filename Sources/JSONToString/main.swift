import Foundation
import Commander
import Files

let main = command(
    Option<String>("json_path", default: ".", description: "parse json files"),
    Option<String>("config_path", default: ".", description: "Manage and run configuration files")
) { (jsonPath, config_path) in
    guard let folder = try? File(path: jsonPath), let data = try? folder.read() else {
        print("not found json file")
        return
    }
    
    do {
        let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as! [[String: Any]]
        do {
            let yaml = try Yaml(path: config_path)
            guard let strings = YamlStringsParser(jsons: yaml.jsons) else {
                print("failure parse yml file")
                return
            }
            strings.outputs.forEach { (output) in
                switch output.format {
                case .xml:
                    let writer = LocalizableFileCreatorForXML(json: json,
                                                              key: output.key,
                                                              valuekey: output.valuekey,
                                                              outputPath: output.output,
                                                              sort: output.sort)
                    do {
                        try writer.write()
                        print("Generate Success!!!")
                    } catch {
                        print(error.localizedDescription)
                    }
                case .strings:
                    let writer = LocalizableFileCreatorForStrings(json: json,
                                                                  key: output.key,
                                                                  valuekey: output.valuekey,
                                                                  outputPath: output.output,
                                                                  sort: output.sort)
                    do {
                        try writer.write()
                        print("Generate Success!!!")
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    } catch {
        print(error.localizedDescription)
    }
}
main.run()
