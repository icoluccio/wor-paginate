#!/usr/bin/env bash
# Boots spec/dummy as a real server under every Appraisal gemfile and curls each route.
# index_exception routes are expected to be non-2xx; everything else should be 2xx.
set -uo pipefail

cd "$(dirname "$0")/.."
ROOT="$(pwd)"
PORT=3099

ROUTES=(
  dummy_models_without_gems
  dummy_models_without_gems/index_scoped
  dummy_models_without_gems/index_total_count
  dummy_models_without_gems/index_scoped_total_count
  dummy_models
  dummy_models/index_array
  dummy_models/index_will_paginate
  dummy_models/index_kaminari
  dummy_models/index_exception
  dummy_models/index_scoped
  dummy_models/index_with_params
  dummy_models/index_with_high_limit
  dummy_models/index_each_serializer
  dummy_models/index_custom_formatter
  dummy_models/index_group_by
  dummy_models/index_custom_adapter
  dummy_models/index_panko_formatter
  dummy_sons
  dummy_sons/index_array
  dummy_sons/index_will_paginate
  dummy_sons/index_kaminari
  dummy_sons/index_exception
  dummy_sons/index_scoped
  dummy_sons/index_with_params
  dummy_sons/index_with_high_limit
  dummy_sons/index_each_serializer
  dummy_sons/index_custom_formatter
  dummy_models_total_count
  dummy_models_total_count/index_array
  dummy_models_total_count/index_will_paginate
  dummy_models_total_count/index_kaminari
  dummy_models_total_count/index_exception
  dummy_models_total_count/index_scoped
  dummy_models_total_count/index_with_params
  dummy_models_total_count/index_with_high_limit
  dummy_models_total_count/index_each_serializer
  dummy_models_total_count/index_group_by
  posts
  posts/index_by_id
)

overall_status=0

for gemfile in "$ROOT"/gemfiles/rails_*.gemfile; do
  version=$(basename "$gemfile" .gemfile)
  echo "=== $version ==="
  export BUNDLE_GEMFILE="$gemfile"
  export RAILS_ENV=development

  (cd spec/dummy && bundle exec rails db:schema:load) || { echo "  schema load FAILED"; overall_status=1; unset BUNDLE_GEMFILE RAILS_ENV; continue; }

  (cd spec/dummy && bundle exec rails server -p "$PORT" -e development) &
  server_pid=$!

  ready=0
  for _ in $(seq 1 30); do
    if curl -s -o /dev/null "http://localhost:$PORT/posts"; then ready=1; break; fi
    sleep 1
  done

  if [ "$ready" -ne 1 ]; then
    echo "  server did not come up"
    overall_status=1
  else
    for route in "${ROUTES[@]}"; do
      code=$(curl -s -o /dev/null -w '%{http_code}' "http://localhost:$PORT/$route")
      printf '  %-3s %s\n' "$code" "$route"
      if [[ "$route" != *index_exception* && ! "$code" =~ ^2 ]]; then
        overall_status=1
      fi
    done
  fi

  kill "$server_pid" 2>/dev/null
  wait "$server_pid" 2>/dev/null
  unset BUNDLE_GEMFILE RAILS_ENV
done

exit $overall_status
