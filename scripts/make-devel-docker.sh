#!/bin/bash
nvidia-docker build  -t opsh2oai/h2o4gpu-${extratag}-build -f Dockerfile-build --rm=false --build-arg cuda=${dockerimage} .
#-u `id -u`:`id -g`  -w `pwd` -v `pwd`:`pwd`:rw
nvidia-docker run --init --rm --name ${CONTAINER_NAME} -d -t -u root -v /home/0xdiag/h2o4gpu/data:/data -v /home/0xdiag/h2o4gpu/open_data:/open_data -v `pwd`:/dot  --entrypoint=bash opsh2oai/h2o4gpu-${extratag}-build
echo "Copying files"
nvidia-docker exec ${CONTAINER_NAME} bash -c 'cp -a /dot/. ./'
echo "setup pyenv, shallow clone, and make fullinstalljenkins"
nvidia-docker exec ${CONTAINER_NAME} bash -c 'eval "$(/root/.pyenv/bin/pyenv init -)" ; /root/.pyenv/bin/pyenv global 3.6.1; ./scripts/gitshallow_submodules.sh ; make ${makeopts} fullinstalljenkins'${extratag}' '${H2O4GPU_BUILD}' '${H2O4GPU_SUFFIX}
echo "Stopping docker"
nvidia-docker stop ${CONTAINER_NAME}
echo "DONE"
