FROM alpine/git:2.45.2 as download

COPY clone.sh /clone.sh

RUN . /clone.sh stable-diffusion-stability-ai https://github.com/Stability-AI/stablediffusion.git cf1d67a6fd5ea1aa600c4df58e5b47da45f6bdbf \
  && rm -rf assets data/**/*.png data/**/*.jpg data/**/*.gif

RUN . /clone.sh CodeFormer https://github.com/sczhou/CodeFormer.git 8392d0334956108ab53d9439c4b9fc9c4af0d66d \
  && rm -rf assets inputs

RUN . /clone.sh BLIP https://github.com/salesforce/BLIP.git 3a29b7410476bf5f2ba0955827390eb6ea1f4f9d
RUN . /clone.sh k-diffusion https://github.com/crowsonkb/k-diffusion.git 21d12c91ad4550e8fcf3308ff9fe7116b3f19a08
RUN . /clone.sh clip-interrogator https://github.com/pharmapsychotic/clip-interrogator bc07ce62c179d3aab3053a623d96a071101d11cb
RUN . /clone.sh generative-models https://github.com/Stability-AI/generative-models fbdc58cab9f4ee2be7a5e1f2e2787ecd9311942f
RUN . /clone.sh stable-diffusion-webui-assets https://github.com/AUTOMATIC1111/stable-diffusion-webui-assets.git 6f7db241d2f8ba7457bac5ca9753331f0c266917


FROM pytorch/pytorch:2.3.1-cuda12.1-cudnn8-runtime

ENV DEBIAN_FRONTEND=noninteractive PIP_PREFER_BINARY=1

RUN --mount=type=cache,target=/var/cache/apt \
  apt-get update && \
  # we need those
  apt-get install -y fonts-dejavu-core rsync git jq moreutils aria2 \
  # extensions needs those
  ffmpeg libglfw3-dev libgles2-mesa-dev pkg-config libcairo2 libcairo2-dev build-essential


WORKDIR /
RUN --mount=type=cache,target=/root/.cache/pip \
  git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git && \
  cd stable-diffusion-webui && \
  git reset --hard feee37d75f1b168768014e4634dcb156ee649c05 && \
  python -m pip install pip --upgrade && \
  pip install -r requirements_versions.txt


ENV ROOT=/stable-diffusion-webui

COPY --from=download /repositories/ ${ROOT}/repositories/
RUN mkdir ${ROOT}/interrogate && cp ${ROOT}/repositories/clip-interrogator/clip_interrogator/data/* ${ROOT}/interrogate
RUN --mount=type=cache,target=/root/.cache/pip \
  pip install -r ${ROOT}/repositories/CodeFormer/requirements.txt

RUN --mount=type=cache,target=/root/.cache/pip \
  pip install pyngrok dctorch xformers==0.0.26.post1 \
  git+https://github.com/TencentARC/GFPGAN.git@7552a7791caad982045a7bbe5634bbf1cd5c8679 \
  git+https://github.com/openai/CLIP.git@dcba3cb2e2827b402d2701e7e1c7d9fed8a20ef1 \
  git+https://github.com/mlfoundations/open_clip.git@1be2c8993b3f2628d495dfa791061e92f1cd4d0e

# there seems to be a memory leak (or maybe just memory not being freed fast enough) that is fixed by this version of malloc
# maybe move this up to the dependencies list.
RUN apt-get -y install libgoogle-perftools-dev && apt-get clean
ENV LD_PRELOAD=libtcmalloc.so

COPY . /docker

RUN \
  # mv ${ROOT}/style.css ${ROOT}/user.css && \
  sed -i 's/in_app_dir = .*/in_app_dir = True/g' /opt/conda/lib/python3.10/site-packages/gradio/routes.py && \
  git config --global --add safe.directory '*'

WORKDIR ${ROOT}
ENV NVIDIA_VISIBLE_DEVICES=all
ENV CLI_ARGS=""
EXPOSE 7860
ENTRYPOINT ["/docker/entrypoint.sh"]
CMD python -u webui.py --listen --port 7860 ${CLI_ARGS}
