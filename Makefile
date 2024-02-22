
VM_PATH = /Users/tookuyam/sgoinfre/debian/debian.vdi
SUBMIT_REPO = git@vogsphere-v2.42tokyo.jp:vogsphere/intra-uuid-e40f3299-df43-4404-8812-b9bb47a612b1-5297232-tookuyam
SIGNATURE = submit/signature.txt

$(SIGNATURE): $(VM_PATH)
	shasum $(VM_PATH) > $(SIGNATURE)

submit: $(SIGNATURE)
	zsh submit.sh

.PHONY: submit