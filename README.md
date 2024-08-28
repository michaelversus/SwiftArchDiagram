# Installation
```bash
brew tap yourusername/swiftarchdiagram https://github.com/michaelversus/SwiftArchDiagram
brew install swiftarchdiagram
```
# Example
Execute the followong command:
```bash
swiftarchdiagram --directory ~/App/Packages --rpath ~/App/SomeApp.xcworkspace/xcshareddata/swiftpm/Package.resolved --with-relations
```
- **directory**: the internal Swift Packages directory that you are using if any
- **rpath**: the path of the main Package.resolved for your project or workspace**
- **with-relations**: add arrows to display dependencies between packages
