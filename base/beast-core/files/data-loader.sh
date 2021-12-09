#!/bin/bash

if [[ -z "$GIT_REPO" ]]; then
  echo "Missing 'GIT_REPO' variable."
  exit 1
fi

if [[ -z "$USERNAME" ]]; then
  echo "Missing 'USERNAME' variable."
  exit 1
fi

if [[ -z "$TOKEN" ]]; then
  echo "ERROR: Missing 'TOKEN' variable."
  exit 1
fi

if [[ -z "$VOLUME_PATH" ]]; then
  echo "ERROR: Missing 'VOLUME PATH' variable."
fi

if [[ "$CLEAR_VOLUME" == "true" ]]; then
    echo "Clearing existing content from '$VOLUME_PATH'.."
    find "$VOLUME_PATH" -mindepth 1 -maxdepth 1 -type d -print0 | xargs -r0 rm -R
    rm -rf $VOLUME_PATH
fi

echo "Pulling data from '$GIT_REPO/' to '$VOLUME_PATH'.."
GIT_LFS_SKIP_SMUDGE=1 git clone "https://$USERNAME:$TOKEN@$GIT_REPO" "$VOLUME_PATH"
cd $VOLUME_PATH
echo "Fetching LFS objects"
echo "Pulling platforms lfs data..."
for D in *; do
  if [ -d "${D}" ]; then
    echo "${D}"
    git lfs pull -I "${D}"
  fi
done
echo "Run lfs fsck.."
git lfs fsck
ls -lhR $VOLUME_PATH