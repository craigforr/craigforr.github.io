serve: ## Serve the site in development mode
	hugo serve --buildDrafts --buildFuture --disableFastRender

build: ## Build the site
	hugo -d public --gc --minify --cleanDestinationDir
