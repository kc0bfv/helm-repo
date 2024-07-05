CHARTS := $(foreach file, $(wildcard */Chart.yaml), $(shell dirname ${file}))

for_gh_pages:
	grep 'repository:' */Chart.yaml | awk '{ print $3 }' | uniq | xargs -rn1 sh -c 'helm repo add $(basename $0) $0'
	helm repo update
	$(foreach dir, ${CHARTS}, helm dependency build --skip-refresh ${dir};)
	$(foreach dir, ${CHARTS}, helm package ${dir};)
	helm repo index . --url https://kc0bfv.github.io/helm-repo/
