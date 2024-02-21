
VM_PATH="/Users/tookuyam/sgoinfre/debian/debian.vdi"
SUBMIT_REPO="git@vogsphere-v2.42tokyo.jp:vogsphere/intra-uuid-e40f3299-df43-4404-8812-b9bb47a612b1-5297232-tookuyam"

submit:
	shasum $(VM_PATH) > submit/signature.txt 
	git init submit
	git add .
	git commit -m "for Submit"
	git remote add origin $(SUBMIT_REPO)
	git branch -M master
	git push origin master
	$(RM) .git
	echo $$HOST > submit_log

.PHONY: submit
