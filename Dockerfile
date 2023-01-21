FROM sagemath/sagemath

WORKDIR /var/task

RUN sudo chown sage:sage /var/task \
 && sudo chmod 777 /home/sage \
 && mkdir /home/sage/.sage \
 && sudo chmod 777 /home/sage/.sage

RUN /home/sage/sage/local/var/lib/sage/venv-python3.10.5/bin/pip3 install boto3

COPY ./src/* ./

CMD ["sh", "run.sh"]
