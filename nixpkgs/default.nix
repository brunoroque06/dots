{ nixpkgs ? <nixpkgs> }:
import nixpkgs {
  config = { allowUnfree = true; };
}
