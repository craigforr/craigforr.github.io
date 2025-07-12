serve: ## Serve the site in development mode
	cd docs/ && hugo serve --buildDrafts --buildFuture --disableFastRender

build: ## Build the site
	cd docs/ && hugo -d public --gc --minify --cleanDestinationDir
