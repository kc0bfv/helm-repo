CHARTS := $(foreach file, $(wildcard */Chart.yaml), $(shell dirname ${file}))

for_gh_pages:
	$(foreach dir, ${CHARTS}, helm package ${dir})
	helm repo index . --url https://kc0bfv.github.io/helm-chart/
