AWS_ACCOUNT :=   personal-admin

host:
	python3 -m http.server

awslogin:
	onetoken create "$(AWS_ACCOUNT)"
	export AWS_PROFILE="$(AWS_ACCOUNT)-session"
	
install-deps:
	npm install serverless -g

clean:
	
