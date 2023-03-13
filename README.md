# CarouselView



![Screen_Recording_2023-03-13_at_22_55_06_AdobeExpress](https://user-images.githubusercontent.com/28716129/224845381-f542024c-3ec5-4147-abe1-66329f64b96a.gif)


## Usage
Add Carousel.swift and CarouselView.swift files to your project

* initilize `Carousel` with available parameters


```Swift
//See example items
Carousel(items: Item.items, duration: 2.0) { item in
                    VStack { //Your Custom view
                        Spacer()
                        Image(systemName: item.image).font(.largeTitle).foregroundColor(.white)
                        Spacer()
                        VStack(spacing:12) {
                            Text(item.title).font(.title2.bold()).foregroundColor(.white)
                            Text(item.description)
                                .foregroundColor(.white.opacity(0.9)).font(.subheadline).multilineTextAlignment(.center).padding(.horizontal,4)
                        }
                        Spacer()
                    }
                }
```


