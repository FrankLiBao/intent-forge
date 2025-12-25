#!/usr/bin/env bash
set -euo pipefail

# create-github-release.sh
# Create a GitHub release with all template zip files
# Usage: create-github-release.sh <version>

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <version>" >&2
  exit 1
fi

VERSION="$1"

# Remove 'v' prefix from version for release title
VERSION_NO_V=${VERSION#v}

gh release create "$VERSION" \
  .genreleases/intent-template-copilot-sh-"$VERSION".zip \
  .genreleases/intent-template-copilot-ps-"$VERSION".zip \
  .genreleases/intent-template-claude-sh-"$VERSION".zip \
  .genreleases/intent-template-claude-ps-"$VERSION".zip \
  .genreleases/intent-template-gemini-sh-"$VERSION".zip \
  .genreleases/intent-template-gemini-ps-"$VERSION".zip \
  .genreleases/intent-template-cursor-agent-sh-"$VERSION".zip \
  .genreleases/intent-template-cursor-agent-ps-"$VERSION".zip \
  .genreleases/intent-template-opencode-sh-"$VERSION".zip \
  .genreleases/intent-template-opencode-ps-"$VERSION".zip \
  .genreleases/intent-template-qwen-sh-"$VERSION".zip \
  .genreleases/intent-template-qwen-ps-"$VERSION".zip \
  .genreleases/intent-template-windsurf-sh-"$VERSION".zip \
  .genreleases/intent-template-windsurf-ps-"$VERSION".zip \
  .genreleases/intent-template-codex-sh-"$VERSION".zip \
  .genreleases/intent-template-codex-ps-"$VERSION".zip \
  .genreleases/intent-template-kilocode-sh-"$VERSION".zip \
  .genreleases/intent-template-kilocode-ps-"$VERSION".zip \
  .genreleases/intent-template-auggie-sh-"$VERSION".zip \
  .genreleases/intent-template-auggie-ps-"$VERSION".zip \
  .genreleases/intent-template-roo-sh-"$VERSION".zip \
  .genreleases/intent-template-roo-ps-"$VERSION".zip \
  .genreleases/intent-template-codebuddy-sh-"$VERSION".zip \
  .genreleases/intent-template-codebuddy-ps-"$VERSION".zip \
  .genreleases/intent-template-qoder-sh-"$VERSION".zip \
  .genreleases/intent-template-qoder-ps-"$VERSION".zip \
  .genreleases/intent-template-amp-sh-"$VERSION".zip \
  .genreleases/intent-template-amp-ps-"$VERSION".zip \
  .genreleases/intent-template-shai-sh-"$VERSION".zip \
  .genreleases/intent-template-shai-ps-"$VERSION".zip \
  .genreleases/intent-template-q-sh-"$VERSION".zip \
  .genreleases/intent-template-q-ps-"$VERSION".zip \
  .genreleases/intent-template-bob-sh-"$VERSION".zip \
  .genreleases/intent-template-bob-ps-"$VERSION".zip \
  --title "Intent Forge Templates - $VERSION_NO_V" \
  --notes-file release_notes.md
