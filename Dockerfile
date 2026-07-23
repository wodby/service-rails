ARG WODBY_BASE_IMAGE
FROM ${WODBY_BASE_IMAGE}

USER root
RUN apk add --no-cache vips && \
    apk add --no-cache --virtual .build-deps build-base

USER wodby
ARG COPY_FROM
COPY --chown=wodby:wodby ${COPY_FROM} /usr/src/app

RUN set -e; \
    if [ -f Gemfile ]; then \
      bundle install; \
      if bundle exec rails --tasks 2>/dev/null | grep -q 'assets:precompile'; then \
        RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile; \
      fi; \
    fi

USER root
RUN apk del .build-deps

USER wodby
