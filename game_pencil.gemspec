Gem::Specification.new do |s|
  s.name = "game_pencil"
  s.version = File.read("VERSION")
  s.authors = ["pasberth"]
  s.description = %{Game pencil}
  s.summary = %q{}
  s.email = "pasberth@gmail.com"
  s.extra_rdoc_files = ["README.rst"]
  s.rdoc_options = ["--charset=UTF-8"]
  s.homepage = "http://github.com/pasberth/GamePencil"
  s.require_paths = ["lib"]
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- spec/*`.split("\n")
end
