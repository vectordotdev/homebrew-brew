# Vector Homebrew Tap

Install the Vector tap with:

    $ brew tap vectordotdev/brew

Then proceed to install Vector brews:

    $ brew install vector

For more information, visit https://github.com/vectordotdev/vector

## Releases

Vector's release workflow starts the [Release Vector](https://github.com/vectordotdev/homebrew-brew/actions/workflows/release.yml)
workflow here after publishing a stable release. It passes the exact version, without the `v` prefix.

The workflow downloads the ARM64 package, updates its URL and SHA256 in `Formula/vector.rb`, checks the Ruby syntax,
and commits directly to this repository's default branch. The Intel package stays pinned to its last supported release.
Equal or older versions are skipped. Concurrent branch changes stop the release instead of being overwritten.

To retry manually, run **Release Vector** with `version` set to the stable Vector version (`X.Y.Z`).
