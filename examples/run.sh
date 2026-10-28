#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_dh_pose info
PYTHONPATH=src python -m gbt_dh_pose check --payload '{}'
PYTHONPATH=src python -m gbt_dh_pose run   --payload '{}'
