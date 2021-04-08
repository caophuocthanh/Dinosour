# DataMine
<div class="text-red mb-2">(In Developing... It's not ready for use)</div>


### TODO:

- [x] Stored Object with Realm by mutithread
- [x] Custom listen on change of list and an object 
- [x] Hidden Realm Framework
- [ ] Custom Lis<Element> of Realm to make an object refercence to many objects
- [ ] Decode & Encode Mapping Object easy
- [ ] Add Alarmofire and make request and store object easier

==> Try hard to rewirte my old source code: https://github.com/caophuocthanh/RealmSwift-Alamofire

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

        print("new")
        let create: Person = Person(id: 10, name: "person")
        
        // listen change at other thread E1
        DispatchQueue(label: "E1").asyncAfter(deadline: .now() + 1) {
            print("observe")
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
        
        // save object at other thread E2
        DispatchQueue(label: "E2").asyncAfter(deadline: .now() + 3) {
            print("insert")
            try! create.insert()
        }
        
        // read object at other thread E12222. use this to access safe properties
        DispatchQueue(label: "E21").asyncAfter(deadline: .now() + 5) {
            print("get")
            DispatchQueue.main.async {
                if let per = Person.get(10) {
                    DispatchQueue(label: "E12222").async {
                        print("object:", per.this?.name)
                    }
                } else {
                    print("get nil")
                }
            }
            
        }
        
        // upadte object at other thread E3
        DispatchQueue(label: "E3").asyncAfter(deadline: .now() + 7) {
            print("write")
            for i in 0...10 {
                sleep(2)
                try? create.write {
                    print("write")
                    create.this?.name = "person🦴 \(i)"
                }
            }
            
            
            // delete object at other thread E4
            sleep(2)
            DispatchQueue(label: "E4").asyncAfter(deadline: .now() + 1) {
                print("delete")
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

