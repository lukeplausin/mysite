AWS_ACCOUNT :=   personal-admin

host:
	python3 -m http.server

awslogin:
	onetoken create "$(AWS_ACCOUNT)"
	export AWS_PROFILE="$(AWS_ACCOUNT)-session"
	
install-deps:
	make clean
	git clone https://github.com/marksteele/netlify-serverless-oauth2-backend.git
	cd netlify-serverless-oauth2-backend
	npm install
	npm install serverless

clean:
	rm -rf netlify-serverless-oauth2-backend
