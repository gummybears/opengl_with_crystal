# stumpy_gif

## Interface

* `StumpyGIF.write(frames : Array(Canvas), path_or_io, delay_between_frames = 10)`
  saves a list of frames (canvasses) as a GIF image file,
  `delay_between_frames` is in 1/100 of a second
* `Canvas` and `RGBA` from [stumpy_core](https://github.com/stumpycr/stumpy_core)

## Usage

### Writing

``` crystal
require "stumpy_gif"
include StumpyGIF

frames = [] of Canvas

(0..5).each do |z|
  canvas = Canvas.new(256, 256)

  (0..255).each do |x|
    (0..255).each do |y|
      color = RGBA.from_rgb_n([x, y, z * 51], 8)
      canvas[x, y] = color
    end
  end

  frames << canvas
end

StumpyGIF.write(frames, "rainbow.gif")
```

Left to right: Websafe, median split, NeuQuant

![GIF image with an animated color gradient](examples/rainbow_websafe.gif)
![GIF image with an animated color gradient](examples/rainbow_median_split.gif)
![GIF image with an animated color gradient](examples/rainbow_neuquant.gif)

(See `examples/` for more examples)

## Color Quantization Methods

* Use Websafe colors
* Median Split
* NeuQuant

## References

* [Kohonen Neural Networks for Optimal Colour Quantization](http://members.ozemail.com.au/~dekker/NeuQuant.pdf)

## Contributors

Thanks goes to these wonderful people ([emoji key](https://github.com/kentcdodds/all-contributors#emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore -->
| [<img src="https://avatars1.githubusercontent.com/u/2060269?v=4" width="100px;"/><br /><sub><b>Leon</b></sub>](http://leonrische.me)<br /> | [<img src="https://avatars1.githubusercontent.com/u/26842759?v=4" width="100px;"/><br /><sub><b>Sam</b></sub>](https://github.com/Demonstrandum)<br /> | [<img src="https://avatars2.githubusercontent.com/u/11375246?v=4" width="100px;"/><br /><sub><b>Stepan Melnikov</b></sub>](https://github.com/unn4m3d)<br />[💻](https://github.com/stumpycr/stumpy_gif/commits?author=unn4m3d "Code") | [<img src="https://avatars1.githubusercontent.com/u/1196822?v=4" width="100px;"/><br /><sub><b>Dmitry Bochkarev</b></sub>](https://github.com/DmitryBochkarev)<br />[💻](https://github.com/stumpycr/stumpy_gif/commits?author=DmitryBochkarev "Code") |
| :---: | :---: | :---: | :---: |
<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/kentcdodds/all-contributors) specification. Contributions of any kind welcome!
