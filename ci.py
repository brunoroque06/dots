import asyncio

import dagger


async def ci():
    async with dagger.Connection() as client:
        src = client.host().directory(".").without_directory("venv")

        shfmt = "/root/go/bin/shfmt"
        list_sh = f"{shfmt} -f ."
        work_dir = "/dots"

        await (
            client.container()
            .from_("ubuntu:latest")
            .with_exec(["apt", "update"])
            .with_exec(["apt", "install", "golang-go", "npm", "shellcheck", "-y"])
            .with_exec(["go", "install", "mvdan.cc/sh/v3/cmd/shfmt@latest"])
            .with_exec(["npm", "install", "-g", "prettier"])
            .with_mounted_directory(work_dir, src)
            .with_workdir(work_dir)
            .with_exec(["prettier", "-c", "."])
            .with_exec(["sh", "-c", f"{list_sh} | xargs -t -I % {shfmt} -d %"])
            .with_exec(["sh", "-c", f"{list_sh} | xargs -t -I % shellcheck -x %"])
            .exit_code()
        )


asyncio.run(ci())
