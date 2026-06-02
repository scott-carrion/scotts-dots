# powerline-gitstatus.nix
{ lib, python3Packages }:

python3Packages.buildPythonPackage rec {
  # This package uses underscore instad of hyphen for its own package
  pname = "powerline_gitstatus";
  version = "1.3.3";
  format = "wheel";

  src = python3Packages.fetchPypi {
    inherit pname version format;
    
    hash = "sha256-clWy79XPOe0VxHYiOjYV36DBmXaUA5lGEFDQ2xxPpd0="; 
    dist = "py3";
    python = "py3";
  };

  # We disable checks because PyPI tarballs often omit the test suite, 
  # or the tests require a live Git repository to pass.
  doCheck = false;

  meta = with lib; {
    description = "A Powerline segment for showing the status of a Git working copy";
    homepage = "https://github.com/jaspernbrouwer/powerline-gitstatus";
    license = licenses.mit;
  };
}
