# JSONToString

Generate a string file from json

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
