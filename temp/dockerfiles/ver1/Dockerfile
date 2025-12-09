FROM alpine:3.21.3

USER root


## shows the echo lines when building this image
RUN set -xa

## allows usage of instruction "source <file>" and later ARG variables from the imported file
# RUN set -a



# ARG ENV_FOLDER_TARGET_PATH="/etc/docker_buildx"

# RUN <<EOF
#   mkdir -p "${ENV_FOLDER_TARGET_PATH}"
#   # chown -R root:root "${ENV_FOLDER_TARGET_PATH}"
#   # chmod -R u+rwx "${ENV_FOLDER_TARGET_PATH}"
#   # chmod -R go-rwx "${ENV_FOLDER_TARGET_PATH}"
# EOF

# ADD ./.env "${ENV_FOLDER_TARGET_PATH}/"
# RUN source "${ENV_FOLDER_TARGET_PATH}/.env"
# ARG USER_NAME
# RUN echo -e "USER_NAME: ${USER_NAME}\n"

# RUN apk add bash
# RUN apk add shadow
# RUN apk add sudo


### ==========================

# ARG ROOT_HASHED_PWD

# ARG GROUP_SUDOERS_ID
# ARG GROUP_SUDOERS_NAME

# ARG GROUP_USERS_ID
# ARG GROUP_USERS_NAME

# ARG USER_SUDOER_ID
# ARG USER_SUDOER_NAME
# ARG USER_SUDOER_HASHED_PWD

# ARG USER_ID
# ARG USER_NAME

# ARG LOGGED_IN_USERNAME

# ARG VOLUME_PATH


# RUN addgroup -g ${GROUP_SUDOERS_ID} ${GROUP_SUDOERS_NAME}
# RUN addgroup -g ${GROUP_USERS_ID} ${GROUP_USERS_NAME}

# RUN adduser -u ${USER_SUDOER_ID} -G ${GROUP_SUDOERS_NAME} -D ${USER_SUDOER_NAME}
# RUN adduser -u ${USER_ID} -G ${GROUP_USERS_NAME} -D ${USER_NAME}

### ==========================

# ENV sudoers_file_name="/etc/sudoers.d/${GROUP_SUDOERS_NAME}"
# RUN echo -e "\n# The custom group in this test image\n%${GROUP_SUDOERS_NAME} ALL=(ALL) ALL\n" >> "${sudoers_file_name}"

# java, rc-service, apk
# RUN echo -e "%${sudoers_file_name} ALL=/usr/bin/less, /usr/bin/apt" >> "${sudoers_file_name}\n\n\n"

# RUN chmod 440 "${sudoers_file_name}"




# RUN echo "${USER_SUDOER_HASHED_PWD}" | passwd --stdin "${USER_SUDOER_NAME}"

# RUN echo "${USER_SUDOER_NAME}:${USER_SUDOER_PWD}" | chpasswd
# RUN echo "${USER_SUDOER_NAME}:${USER_SUDOER_HASHED_PWD}" | chpasswd -e



# This umask (027) balances security and usability:
# Directories: 750 (rwxr-x---)
# Files: 640 (rw-r-----)
# RUN echo -e "\umask 027\n\n\n" >> "/etc/profile"

# RUN echo "${ROOT_HASHED_PWD}" | passwd --stdin "root"
# RUN echo "root:${ROOT_HASHED_PWD}" | chpasswd -e


# RUN apk add openjdk21-jre

# Capture the host machine architecture
ARG BUILDPLATFORM
ARG BUILDOS
ARG BUILDARCH

# Capture the target architecture
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

ARG ECHO_LINE="Building under host machine platform: ${BUILDPLATFORM} ${BUILDOS} ${BUILDARCH}, for the target architecture: ${TARGETPLATFORM} ${TARGETOS} ${TARGETARCH}"

RUN echo -e "${ECHO_LINE}\n"


# Install OpenJDK based on architecture

ARG TMP_ENV_PATH="/etc/tmpenv"
RUN touch "${TMP_ENV_PATH}"
RUN chmod +x "${TMP_ENV_PATH}"

ARG MULTIPLATFORM_FUNCS_PATH="./.command/docker/multiplatform/alpine_url.sh"
ARG SCRIPTS_PATH="/var/docker_buildx"
RUN mkdir -p "${SCRIPTS_PATH}"
COPY "${MULTIPLATFORM_FUNCS_PATH}" "${SCRIPTS_PATH}/alpine_url.sh"
RUN chmod +x "${SCRIPTS_PATH}/alpine_url.sh"
RUN ls -la "${SCRIPTS_PATH}" | grep "alpine_url.sh"
RUN cat "${SCRIPTS_PATH}/alpine_url.sh"

# RUN source "${SCRIPTS_PATH}/alpine_url.sh"
# ENV ALPINE_COMMUNITY_URL="$(get_alpine_url "${TARGETPLATFORM}")""
# RUN echo -e "${ALPINE_COMMUNITY_URL}\n"


ENV ALPINE_COMMUNITY_URL=""
RUN sh -c ""${SCRIPTS_PATH}/alpine_url.sh" "${TARGETPLATFORM}"" > "${TMP_ENV_PATH}"
RUN ls -la "${TMP_ENV_PATH}"
RUN cat "${TMP_ENV_PATH}"
# RUN source "${TMP_ENV_PATH}"
ENV ALPINE_COMMUNITY_URL="$(cat "${TMP_ENV_PATH}")"
RUN echo "${ALPINE_COMMUNITY_URL}"


### "${TMP_ENV_PATH}"
# RUN ls -la "${TMP_ENV_PATH}"
# RUN cat "${TMP_ENV_PATH}"

# RUN set -xa
# RUN source "${TMP_ENV_PATH}"
#RUN get_alpine_url "${TARGETPLATFORM}"
# ARG ALPINE_COMMUNITY_URL=""

#="$(get_alpine_url "${TARGETPLATFORM}")"
# RUN echo -e "${ALPINE_COMMUNITY_URL}\n"

# RUN echo -e "\nALPINE_COMMUNITY_URL=" > "${TMP_ENV_PATH}"
# RUN get_alpine_url "${TARGETPLATFORM}" >> "${TMP_ENV_PATH}"
# RUN echo -e "\n\n\n" >> "${TMP_ENV_PATH}"

# RUN source "${TMP_ENV_PATH}"


# # Use the variable in subsequent instructions
# ARG ALPINE_COMMUNITY_RELEASE_URL="https://dl-cdn.alpinelinux.org/alpine/v3.21/community/${ARCH}"
# RUN echo "ALPINE_COMMUNITY_RELEASE_URL: ${ALPINE_COMMUNITY_RELEASE_URL}"

# Clean up
# RUN rm ${TMP_ENV_PATH}

# RUN apk add --no-cache openjdk21-jre --repository="${ALPINE_COMMUNITY_RELEASE_URL}" || \
#     (echo "No suitable OpenJDK version found for ${ALPINE_ARCHITECTURE}" && exit 1)



# WORKDIR "${VOLUME_PATH}"
# USER "${LOGGED_IN_USERNAME}"


# RUN apk add --no-cache curl

# loading NVM
# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

# ENV NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# RUN set +xa

CMD [ "tail", "-f", "/dev/null" ]




