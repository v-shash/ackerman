FROM amazon/aws-cli

RUN yum install -y jq gzip nano tar git unzip wget

RUN curl -o /tmp/terraform.zip -LO https://releases.hashicorp.com/terraform/0.14.8/terraform_0.14.8_linux_amd64.zip
RUN unzip /tmp/terraform.zip
RUN chmod +x terraform && mv terraform /usr/local/bin/
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

RUN curl "https://bootstrap.pypa.io/pip/2.7/get-pip.py" -o "/tmp/get-pip.py"
RUN python /tmp/get-pip.py
RUN pip install requests pytest

ENTRYPOINT ["/bin/sh", "-c"]

CMD [ "./deploy.sh" ]