# JSONToString

Generate a string file from json.
You can generate strings and xml from json

## Installation
### Makefile
```sh
$ git clone git@github.com:t-osawa-009/JSONToString.git
$ cd JSONToString
$ make install
```

### [Mint](https://github.com/yonaskolb/Mint)
```sh
$ brew install mint
$ mint install t-osawa-009/JSONToString
```

## Usage
1. Prepare the json that will be the original data of the string.
```json
#Strings.json
[
    {
      "key": "hoge",
      "key_android": "hoge",
      "key_ios": "hoge",
      "value_android": "hoge",
      "value_ios": "hoge"
    },
]
```

2. Added JSONToString.yml to set the generation method.

```yml
outputs:
  - key: key
    value_key: value_ios
    output: Strings/Localizable.strings
    format: strings
    sort: asc
  - key: key
    value_key: value_android
    output: Strings/strings.xml
    format: xml
```

3. Execute the command.
```sh
$ JSONToString --json_path Strings.json
```

## Reference Resources
- [Pairs Global iOSでのクールな多言語管理](https://medium.com/eureka-engineering/pairs-global-ios%E3%81%A7%E3%81%AE%E3%82%AF%E3%83%BC%E3%83%AB%E3%81%AA%E5%A4%9A%E8%A8%80%E8%AA%9E%E7%AE%A1%E7%90%86-b91010b063cb)

## CONTRIBUTING
- There's still a lot of work to do here. We would love to see you involved. You can find all the details on how to get started in the Contributing Guide.

## License
JSONToString is released under the MIT license. See LICENSE for details.
