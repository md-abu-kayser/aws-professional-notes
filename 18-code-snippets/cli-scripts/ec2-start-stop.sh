#!/usr/bin/env bash
#
# ec2-start-stop.sh
#
# Start or stop EC2 instances by tag, useful for scheduling
# non-production environments to save cost outside business hours.
#
# Usage:
#   ./ec2-start-stop.sh start Environment=dev
#   ./ec2-start-stop.sh stop  Environment=dev

set -euo pipefail

ACTION="${1:-}"
TAG_FILTER="${2:-}"

if [[ -z "$ACTION" || -z "$TAG_FILTER" ]]; then
  echo "Usage: $0 <start|stop> <Key=Value tag filter>"
  echo "Example: $0 stop Environment=dev"
  exit 1
fi

TAG_KEY="${TAG_FILTER%%=*}"
TAG_VALUE="${TAG_FILTER#*=}"

echo "Looking up instances with tag ${TAG_KEY}=${TAG_VALUE} ..."

INSTANCE_IDS=$(aws ec2 describe-instances \
  --filters "Name=tag:${TAG_KEY},Values=${TAG_VALUE}" \
            "Name=instance-state-name,Values=running,stopped" \
  --query "Reservations[].Instances[].InstanceId" \
  --output text)

if [[ -z "$INSTANCE_IDS" ]]; then
  echo "No matching instances found."
  exit 0
fi

echo "Found instances: ${INSTANCE_IDS}"

case "$ACTION" in
  start)
    aws ec2 start-instances --instance-ids $INSTANCE_IDS
    echo "Start request sent."
    ;;
  stop)
    aws ec2 stop-instances --instance-ids $INSTANCE_IDS
    echo "Stop request sent."
    ;;
  *)
    echo "Unknown action: $ACTION (expected 'start' or 'stop')"
    exit 1
    ;;
esac
