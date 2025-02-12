# build package for distribution
FROM python:3.8 AS build-stage

# update packages
RUN pip install pipenv

COPY . /sourceassist

WORKDIR /sourceassist

RUN pipenv install --dev
RUN pipenv run python setup.py sdist bdist_wheel
RUN cp -r ./dist /dist


# copy and install to lightweight container
FROM python:alpine AS app-container

RUN apk update
RUN apk add --no-cache git docker
COPY --from=build-stage /dist /dist
WORKDIR /dist
RUN pip install "$(ls *.whl)"
WORKDIR /
RUN rm -rf /dist

ENTRYPOINT ["sa"]
CMD ["--help"]
