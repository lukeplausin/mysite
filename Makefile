AWS_ACCOUNT := personal-admin
VIRTUALENV  := cms
PYTHON_DEPS := sceptre
SITE_DOMAIN := stat.luke.plaus.in
SITE_BUCKET := stat-luke-plaus-in

host:
	python3 -m http.server

awslogin:
	onetoken create "$(AWS_ACCOUNT)"
	export AWS_PROFILE="$(AWS_ACCOUNT)-session"
	
install-deps:
	source /usr/local/bin/virtualenvwrapper.sh && workon "$(VIRTUALENV)" && pip install $(PYTHON_DEPS)

install-plugin-deps:
	make clean
	git clone https://github.com/marksteele/netlify-serverless-oauth2-backend.git
	cd netlify-serverless-oauth2-backend && \
		npm install && \
		npm install serverless

deploy-infra:
	export AWS_PROFILE="$(AWS_ACCOUNT)-session" && sceptre launch mysite/site -y

deploy-site:
	aws s3 sync dist "s3://$(SITE_BUCKET)"
	aws s3api put-object-acl --bucket $(SITE_BUCKET) --key admin/config.yml --acl public-read
	aws s3api put-object-acl --bucket $(SITE_BUCKET) --key admin/index.html --acl public-read

deploy-all:
	make awslogin
	make deploy-infra
	make deploy-site

clean-site:
	mkdir .empty && aws s3 sync .empty "s3://$(SITE_BUCKET)" && rmdir .empty

clean:
	make clean-site
	rm -rf netlify-serverless-oauth2-backend
