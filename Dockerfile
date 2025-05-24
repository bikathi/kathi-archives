FROM ghcr.io/getzola/zola:v0.17.1 AS zola

COPY . /project
WORKDIR /project
RUN ["apt", "install", "-y", "git"]
RUN ["git", "submodule", "add", "-b", "latest", "https://github.com/isunjn/serene.git", "themes/serene"]
RUN ["zola", "build"]

FROM ghcr.io/static-web-server/static-web-server:2
WORKDIR /
COPY --from=zola /project/public /public