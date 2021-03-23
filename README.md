# DataMine
<div class="text-red mb-2">(In Developing... It's not ready for use)</div>




### Network and Database in ONE


# Use:

### Command build DataMine.framework and open folder Build after build done

```shell

make setup && make build

````

------------------------

### Setup code
Incude 2 framework:
1. Alamofire
2. RealmSwift

Run this command to get those frameworks from git to this project before run build or test

```shell

make setup

```

### Build
```shell

make build

```

### Test
```shell

make test

``` 

### Clean
```shell

make clean

``` 

### Example

```swift
let create: Person = Person(id: 10, name: "person")
        
        DispatchQueue(label: "E1").sync {
            self.bag = create.observe(on: DispatchQueue.main) { (change) in
                switch change {
                case .initial(let person):
                    print("notify initial:", Thread.current.name ?? "unknow", person.name)
                case .update(let person):
                    print("notify update:", Thread.current.name ?? "unknow", person.name)
                case .delete:
                    print("notify delete:", Thread.current.name ?? "unknow")
                case .error(let error):
                    print("error", error)
                }
            }
        }
        
        DispatchQueue(label: "E2").sync {
            try! create.insert()
        }
        
        DispatchQueue(label: "E3").async {
            for i in 0...10 {
                sleep(2)
                try? create.write {
                    print("write")
                    create.this?.name = "person🦴 \(i)"
                }
            }
            
            sleep(2)
            DispatchQueue(label: "E4").async {
                try? create.delete()
            }
        }

```

## Refactor code from source: 
- https://github.com/caophuocthanh/RealmSwift-Alamofire

## Contact
- Email: caophuocthanh@gmail.com
- Site: https://onebuffer.com
- Linkedin: https://www.linkedin.com/in/caophuocthanh/

