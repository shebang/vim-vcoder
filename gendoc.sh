#!/bin/sh
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

VIMDOC=${HOME}/dev/me/vim/forked/github.com/google/vimdoc/scripts/vimdoc
export PYTHONPATH=${HOME}/dev/me/vim/forked/github.com/google/vimdoc
python3 -m vimdoc ${SCRIPT_DIR}
