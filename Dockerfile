FROM sagemath/sagemath

WORKDIR /var/task

RUN sudo chown sage:sage /var/task \
 && sudo chmod 777 /home/sage \
 && mkdir /home/sage/.sage \
 && sudo chmod 777 /home/sage/.sage

RUN sudo apt-get update && sudo apt-get install -y \
    ca-certificates \
    curl \
    unzip \
 && sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
 && sudo unzip awscliv2.zip \
 && sudo ./aws/install -i /usr/local/aws-cli -b /usr/bin \
 && sudo rm -f awscliv2.zip

RUN /home/sage/sage/local/var/lib/sage/venv-python3.10.5/bin/pip3 install boto3

COPY ./src/* ./

CMD ["sh", "run.sh"]
