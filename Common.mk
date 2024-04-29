all: dist

.PHONY: clean
clean:
	rm -rf coverage dist node_modules

dist: node_modules $(TS_FILES) tsconfig.json tsconfig-build.json Makefile
	rm -rf $@
	pnpm tsc -p tsconfig-build.json

.PHONY: lint
lint: node_modules
	pnpm prettier --check 'src/**/*.{js,ts,json,md,yml}'
	pnpm eslint src/ --max-warnings 0

node_modules: package.json
	pnpm install || (rm -rf $@; exit 1)
	test -d $@ && touch $@ || true

.PHONY: test
test:
	cd ../.. && make
	pnpm c8 --reporter=none ts-mocha --bail 'src/**/*.spec.ts' \
		&& pnpm c8 report --all --clean -n src -x 'src/**/*.spec.ts' -x 'src/types.*' --reporter=text