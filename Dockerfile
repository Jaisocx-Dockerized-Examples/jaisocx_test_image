FROM alpine:3.21.3

USER root


ARG APPLY_SUDOERS_AND_PASSWORDS="false"
ARG INSTALL_BASH="false"
ARG INSTALL_NODE="false"
ARG INSTALL_PHP="false"
ARG INSTALL_JAVA="true"
ARG JAVA_LIBRARY_NAME="openjdk21-jre" 

# ARG CACHE="--no-cache"
ARG CACHE=""


## shows the echo lines when building this image
RUN set -x

## allows instruction "source <file>" and later ARG variables binding from the imported file
RUN set -a




### --------------------------
### grants in docker on filesystem 
#### This umask (027) balances security and usability:
#### Directories: 750 (rwxr-x---)
#### Files: 640 (rw-r-----)
### ==========================
RUN echo -e "\umask 027\n\n\n" >> "/etc/profile"






ARG const_sh_file_first_line="#!/usr/bin/env sh"

### path to .env settings file
ARG SRC_ENV_FILE_PATH="./.env"

## create local image filesystem folder for copy files reusable block
ARG LOCAL_IMAGE_SETTINGS_FOLDER_PATH="/etc/jaisocx_testimage"
ARG LOCAL_IMAGE_SETTINGS_ENV_FOLDER_PATH="${LOCAL_IMAGE_SETTINGS_FOLDER_PATH}/env"
ENV ENV_FILE="${LOCAL_IMAGE_SETTINGS_ENV_FOLDER_PATH}/.env"


RUN mkdir -p "${LOCAL_IMAGE_SETTINGS_FOLDER_PATH}"
RUN mkdir -p "${LOCAL_IMAGE_SETTINGS_ENV_FOLDER_PATH}"


RUN chmod -R u+rwx "${LOCAL_IMAGE_SETTINGS_FOLDER_PATH}"
RUN chmod -R go-rwx "${LOCAL_IMAGE_SETTINGS_FOLDER_PATH}"

RUN chmod -R u+rwx "${LOCAL_IMAGE_SETTINGS_ENV_FOLDER_PATH}"
RUN chmod -R go-rwx "${LOCAL_IMAGE_SETTINGS_ENV_FOLDER_PATH}"





## copy file reusable block
COPY "${SRC_ENV_FILE_PATH}" "${ENV_FILE}"

RUN chmod u+rx "${ENV_FILE}"
RUN chmod u-w "${ENV_FILE}"
RUN chmod go-rwx "${ENV_FILE}"

# preview after copy and grantied access
# RUN ls -lahrts "${ENV_FILE}"
# RUN cat "${ENV_FILE}"



ARG LOCAL_ENV_LIKE_TMP_FILE_PATH="${LOCAL_IMAGE_SETTINGS_ENV_FOLDER_PATH}/.env.tmp"
RUN touch "${LOCAL_ENV_LIKE_TMP_FILE_PATH}"
RUN chmod a+rwx "${LOCAL_ENV_LIKE_TMP_FILE_PATH}"
RUN chmod go-rwx "${LOCAL_ENV_LIKE_TMP_FILE_PATH}"

# preview after copy and grantied access
# RUN echo "${LOCAL_ENV_LIKE_TMP_FILE_PATH}"
# RUN ls -lahrts "${LOCAL_ENV_LIKE_TMP_FILE_PATH}"
# RUN cat "${LOCAL_ENV_LIKE_TMP_FILE_PATH}"



### --------------------------
### Build time DOCKER BUILDX BUILD --build-arg USER_NAME="${USER_NAME}" ASSIGNED ENVIRONMENT VARIABLES from .env 
### ==========================

ARG ROOT_HASHED_PWD

ARG GROUP_SUDOERS_ID
ARG GROUP_SUDOERS_NAME

ARG GROUP_USERS_ID
ARG GROUP_USERS_NAME

ARG USER_SUDOER_ID
ARG USER_SUDOER_NAME
ARG USER_SUDOER_HASHED_PWD

ARG USER_ID
ARG USER_NAME

ARG LOGGED_IN_USERNAME

ARG VOLUME_PATH
ENV ENV_VOL_PATH="${VOLUME_PATH}"





### --------------------------
### INSTALLL PACKAGES 
### ==========================

RUN <<EOF
  if [[ "${APPLY_SUDOERS_AND_PASSWORDS}" == "true" ]]; then
    apk add sudo
    apk add shadow
  fi

  if [[ "${INSTALL_BASH}" == "true" ]]; then
    apk add bash
  fi

EOF

# RUN apk add bash
# RUN apk add shadow
# RUN apk add sudo

RUN apk add curl




# ### --------------------------
# ### paths on host machine ssd drive
# ### ==========================
# ARG SRC_SCRIPTS_PATH="./.command/docker"
# ARG SRC_IMAGE_SCRIPTS_ALPINE_MULTIPLATFORM_FOLDER_PATH="${SRC_SCRIPTS_PATH}/multiplatform"
# ARG SRC_ALPINE_MULTIPLATFORM_FUNCS_PATH="${SRC_IMAGE_SCRIPTS_ALPINE_MULTIPLATFORM_FOLDER_PATH}/alpine_url.sh"




# ### --------------------------
# ### paths in docker container filesystem
# ### ==========================
# ARG LOCAL_IMAGE_SCRIPTS_FOLDER_PATH="${LOCAL_IMAGE_SETTINGS_FOLDER_PATH}/scripts"
# ARG LOCAL_IMAGE_SCRIPTS_ALPINE_MULTIPLATFORM_FOLDER_PATH="${LOCAL_IMAGE_SCRIPTS_FOLDER_PATH}/multiplatform"
# ARG LOCAL_ALPINE_MULTIPLATFORM_FUNC_PATH="${LOCAL_IMAGE_SCRIPTS_ALPINE_MULTIPLATFORM_FOLDER_PATH}/alpine_url.sh"



# RUN mkdir -p "${LOCAL_IMAGE_SCRIPTS_FOLDER_PATH}"
# RUN chmod u+rwx "${LOCAL_IMAGE_SETTINGS_FOLDER_PATH}"
# RUN chmod go-rwx "${LOCAL_IMAGE_SETTINGS_FOLDER_PATH}"


# RUN mkdir -p "${LOCAL_IMAGE_SCRIPTS_ALPINE_MULTIPLATFORM_FOLDER_PATH}"
# RUN chmod u+rwx "${LOCAL_IMAGE_SCRIPTS_ALPINE_MULTIPLATFORM_FOLDER_PATH}"
# RUN chmod go-rwx "${LOCAL_IMAGE_SCRIPTS_ALPINE_MULTIPLATFORM_FOLDER_PATH}"


# COPY "${SRC_ALPINE_MULTIPLATFORM_FUNCS_PATH}" "${LOCAL_ALPINE_MULTIPLATFORM_FUNC_PATH}"
# RUN chmod u+rx "${LOCAL_ALPINE_MULTIPLATFORM_FUNC_PATH}"
# RUN chmod u-w "${LOCAL_ALPINE_MULTIPLATFORM_FUNC_PATH}"
# RUN chmod go-rwx "${LOCAL_ALPINE_MULTIPLATFORM_FUNC_PATH}"

# preview after copy and grantied access
# RUN ls -lahrts "${LOCAL_ALPINE_MULTIPLATFORM_FUNC_PATH}"
# RUN cat "${LOCAL_ALPINE_MULTIPLATFORM_FUNC_PATH}"




# ### --------------------------
# ### IMPORTING FUNCTIONS
# ### ==========================
# RUN source "${LOCAL_ALPINE_MULTIPLATFORM_FUNC_PATH}"








### --------------------------
### mapping a volume reusable block
### ==========================

### TESTED
##### 1. DONE: these volumes are mapped to the host machine folders
# ENV MAPPED_VOLUMES=(log="/var/log" data="${ENV_VOL_PATH}")


ENV MAPPED_VOL_DATA="${ENV_VOL_PATH}"
RUN mkdir -p "${MAPPED_VOL_DATA}"
RUN chmod u+rwx "${MAPPED_VOL_DATA}"
RUN chmod g+rw "${MAPPED_VOL_DATA}"
RUN chmod go-x "${MAPPED_VOL_DATA}"
RUN chmod o-rw "${MAPPED_VOL_DATA}"
VOLUME [ "./data", "${MAPPED_VOL_DATA}" ]


ENV MAPPED_VOL_LOG="/var/log"
RUN mkdir -p "${MAPPED_VOL_LOG}"
RUN chmod u+rwx "${MAPPED_VOL_LOG}"
RUN chmod g+rw "${MAPPED_VOL_LOG}"
RUN chmod go-x "${MAPPED_VOL_LOG}"
RUN chmod o-rw "${MAPPED_VOL_LOG}"
VOLUME [ "./log", "${MAPPED_VOL_LOG}" ]


### TESTED
##### 2. TESTED SUGGESTION FAIL: did not write the file, nor on docker image build, neither when docker compose up.
# RUN echo "Hu hu" > "${MAPPED_VOL_DATA}/test_VOL_mapped.txt"






### --------------------------
### Users and Groups
### ==========================

RUN <<EOF
  ## allows instruction "source <file>" and later ARG variables binding from the imported file
  set -a
  source "${ENV_FILE}"

  addgroup -g ${GROUP_SUDOERS_ID} ${GROUP_SUDOERS_NAME}
  addgroup -g ${GROUP_USERS_ID} ${GROUP_USERS_NAME}

  adduser -u ${USER_SUDOER_ID} -G ${GROUP_SUDOERS_NAME} -D ${USER_SUDOER_NAME}
  adduser -u ${USER_ID} -G ${GROUP_USERS_NAME} -D ${USER_NAME}



  ### SUDOERS USERS AND GROUPS 
  ### ==========================


  sudoers_file_name="/etc/sudoers.d/${GROUP_SUDOERS_NAME}"
  touch "${sudoers_file_name}"
  chmod u+rw "${sudoers_file_name}"

  ## USE FUNC ARRAY JOIN(): # echo_lines = ( "\n" "# The custom group in this test image" "\n" "%${GROUP_SUDOERS_NAME} ALL=(ALL) ALL" "\n" )
  echo -e "# The custom group in this test image\n%${GROUP_SUDOERS_NAME} ALL=(ALL) ALL\n\n" >> "${sudoers_file_name}"

  ## NOT TESTED # GRANTED INVOKE COMMANDS e.g. java, rc-service, apk
  ## USE FUNC ARRAY JOIN(): # echo_lines = ( "%${GROUP_SUDOERS_NAME} ALL=" "/usr/bin/less" ", " "/usr/bin/apt" "\n" )
  # echo -e "%${GROUP_SUDOERS_NAME} ALL=/usr/bin/less, /usr/bin/apt" >> "${sudoers_file_name}"

  chmod 440 "${sudoers_file_name}"




  ### --------------------------
  ### sudoers users passwords ### lib shadow
  ### ==========================

  if [[ "${APPLY_SUDOERS_AND_PASSWORDS}" == "true" ]]; then
    echo "root:${ROOT_HASHED_PWD}" | chpasswd -e
    echo "${USER_SUDOER_NAME}:${USER_SUDOER_HASHED_PWD}" | chpasswd -e
    # echo "${USER_SUDOER_NAME}:${USER_SUDOER_PWD}" | chpasswd
  fi


  ## turns off the setting, allowed instruction "source <file>" and later ARG variables binding from the imported file
  set +a
EOF







### --------------------------
### MULTIPLATFORM BUILD BY DOCKER BUILDX
### ==========================

# Capture the target architecture
ARG TARGETPLATFORM
RUN echo "Building for the target architecture: ${TARGETPLATFORM}"




# ### --------------------------
# ### ACCORDING TO ARCHITECTURE, INSTALL LIBRARIES
# ### ==========================

# ### --------------------------
# ### get Alpine Community Repo url
# ### ==========================


# ##### NOT TESTED
# ##### IN DEVELOPMENT


# RUN <<EOF
#   source "${LOCAL_ALPINE_MULTIPLATFORM_FUNC_PATH}"
#   ALPINE_COMMUNITY_URL="$(get_alpine_url "${TARGETPLATFORM}")"
#   ALPINE_COMMUNITY_RELEASE_URL="https://dl-cdn.alpinelinux.org/alpine/v3.21/community/${ALPINE_COMMUNITY_URL}"

#   # erases the file and writes new line
#   echo "ALPINE_COMMUNITY_URL=\"${ALPINE_COMMUNITY_URL}\"" > "${LOCAL_ENV_LIKE_TMP_FILE_PATH}"

#   # adds other new line
#   echo "ALPINE_COMMUNITY_RELEASE_URL=\"${ALPINE_COMMUNITY_RELEASE_URL}\"" >> "${LOCAL_ENV_LIKE_TMP_FILE_PATH}"

#   # echo for the preview in docker logs
#   echo "${ALPINE_COMMUNITY_URL}"
#   # echo "ALPINE_COMMUNITY_RELEASE_URL=${ALPINE_COMMUNITY_RELEASE_URL}"
# EOF








### --------------------------
### Install based on architecture
### INSTALL JAVA
### ==========================

ARG INSTALL_LIBRARY="${INSTALL_JAVA}"
ARG LIBRARY_NAME="${JAVA_LIBRARY_NAME}"

RUN <<EOF

  if [[ "${INSTALL_LIBRARY}" == "true" ]]; then

    # set -a
    ### FOR NOW THE FUNCTION IS NOT BEING IMPORTED
    # source "${LOCAL_ENV_LIKE_TMP_FILE_PATH}"
    
    repo_url="https://dl-cdn.alpinelinux.org/alpine/v3.21/community/"
    apk add "${LIBRARY_NAME}" $CACHE --repository="${repo_url}"

    # apk add "${LIBRARY_NAME}" --repository="${ALPINE_COMMUNITY_RELEASE_URL}" || \
    #     (echo "No suitable ${LIBRARY_NAME} version found for ${TARGETPLATFORM} on Alpine url community/${ALPINE_COMMUNITY_URL}" && exit 1)

    # set +a

  fi

EOF





### --------------------------
### Install based on architecture
### INSTALL NVM, NODE, NPM, YARN
### ==========================

### --------------------------
### Install based on architecture
### 1. INSTALL NVM
### ==========================

##### NOT TESTED

# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

# ENV NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# RUN <<EOF

#   if [[ "${INSTALL_NODE}" == "true" ]]; then

#     apk add bash
#     curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
#     NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
#     echo "NVM_DIR=\"${NVM_DIR}\"" >> "/etc/profile"

#   fi

# EOF





### --------------------------
### THE FINAL DOCKERIZED SERVICE SETTINGS
### ==========================

WORKDIR "${ENV_VOL_PATH}"

USER "${LOGGED_IN_USERNAME}"


## turns off the settings, allowed instruction "source <file>" and show echo in docker logs
RUN set +xa





### --------------------------
### START OF THE DOCKERIZED SERVICE 
### ==========================

### the placeholder here, this is no good)) rather a service to start in the foreground
CMD [ "tail", "-f", "/dev/null" ]


