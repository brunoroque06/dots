package dots

import (
	"dagger.io/dagger"
	"universe.dagger.io/bash"
	"universe.dagger.io/docker"
)

dagger.#Plan & {
	client: filesystem: ".": read: {
		contents: dagger.#FS
		exclude: [
			"cue.mod",
			"*.cue",
		]
	}

	actions: {
		img: docker.#Build & {
			steps: [
				docker.#Pull & {
					source: "ubuntu:latest"
				},
				docker.#Run & {
					command: {
						name: "apt"
						args: ["update"]
					}
				},
				docker.#Run & {
					command: {
						name: "apt"
						args: ["install", "golang-go", "npm", "shellcheck", "-y"]
					}
				},
				docker.#Run & {
					command: {
						name: "go"
						args: ["install", "mvdan.cc/sh/v3/cmd/shfmt@latest"]
					}
				},
				docker.#Run & {
					command: {
						name: "npm"
						args: ["install", "-g", "@johnnymorganz/stylua-bin", "prettier"]
					}
				},
				docker.#Set & {
					input: _
					config: env: PATH: "/root/go/bin:\(input.config.env.PATH)"
				},
				docker.#Set & {
					config: workdir: "/dots"
				},
				docker.#Copy & {
					contents: client.filesystem.".".read.contents
					dest:     "/dots"
				},
			]
		}

		check: {
			luafmt: bash.#Run & {
				input: img.output
				script: contents: "stylua --check --verbose ."
			}
			prettier: bash.#Run & {
				input: img.output
				script: contents: "prettier -c '**/*.{json,md,yaml,yml}' --loglevel debug"
			}
			shfmt: bash.#Run & {
				input: img.output
				script: contents: "shfmt -f . | xargs -t -I % shfmt -d %"
			}
			shlint: bash.#Run & {
				input: img.output
				script: contents: "shfmt -f . | xargs -t -I % shellcheck -x %"
			}
		}
	}
}
