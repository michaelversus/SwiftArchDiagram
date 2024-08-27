class Swiftarchdiagram < Formula
  desc "Swift Architecture diagram generation using mermaid"
  homepage "https://github.com/michaelversus/SwiftArchDiagram"
  url "https://github.com/michaelversus/SwiftArchDiagram.git", tag: "0.1.4"
  version "0.1.4"

  depends_on "xcode": [:build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}SwiftArchDiagram", "list"
  end
end
