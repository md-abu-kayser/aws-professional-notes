#!/usr/bin/env bash
#
# snapshot-cleanup.sh
#
# Deletes EBS snapshots owned by the current account that are older
# than a given number of days. Useful for keeping storage costs down
# when snapshots aren't managed by a Data Lifecycle Manager policy.
#
# Usage:
#   ./snapshot-cleanup.sh 30       # delete snapshots older than 30 days
#   ./snapshot-cleanup.sh 30 --dry-run

set -euo pipefail

DAYS="${1:-30}"
DRY_RUN="${2:-}"

CUTOFF_EPOCH=$(date -d "-${DAYS} days" +%s 2>/dev/null || date -v-"${DAYS}"d +%s)

echo "Finding snapshots older than ${DAYS} days..."

aws ec2 describe-snapshots --owner-ids self \
  --query "Snapshots[].[SnapshotId,StartTime]" \
  --output text | while read -r SNAPSHOT_ID START_TIME; do

  SNAPSHOT_EPOCH=$(date -d "${START_TIME}" +%s 2>/dev/null || date -jf "%Y-%m-%dT%H:%M:%S" "${START_TIME%.*}" +%s)

  if [[ "$SNAPSHOT_EPOCH" -lt "$CUTOFF_EPOCH" ]]; then
    if [[ "$DRY_RUN" == "--dry-run" ]]; then
      echo "[DRY RUN] Would delete ${SNAPSHOT_ID} (created ${START_TIME})"
    else
      echo "Deleting ${SNAPSHOT_ID} (created ${START_TIME})"
      aws ec2 delete-snapshot --snapshot-id "${SNAPSHOT_ID}"
    fi
  fi
done

echo "Done."
