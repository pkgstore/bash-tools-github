#!/usr/bin/bash -e

(( EUID == 0 )) && { echo >&2 "This script should not be run as root!"; exit 1; }

# -------------------------------------------------------------------------------------------------------------------- #
# CONFIGURATION.
# -------------------------------------------------------------------------------------------------------------------- #

curl="$( command -v curl )"
sleep="2"

# Help.
read -r -d '' help <<- EOF
Options:
  -x 'TOKEN'                            GitHub user token.
  -o 'OWNER_OLD'                        OLD repository owner (organization).
  -n 'OWNER_NEW'                        NEW repository owner (organization).
  -r 'REPO_1;REPO_2;REPO_3'             Repository name array.
EOF

# -------------------------------------------------------------------------------------------------------------------- #
# OPTIONS.
# -------------------------------------------------------------------------------------------------------------------- #

OPTIND=1

while getopts "x:o:n:r:h" opt; do
  case ${opt} in
    x)
      token="${OPTARG}"
      ;;
    o)
      owner_old="${OPTARG}"
      ;;
    n)
      owner_new="${OPTARG}"
      ;;
    r)
      repos="${OPTARG}"; IFS=';' read -ra repos <<< "${repos}"
      ;;
    h|*)
      echo "${help}"
      exit 2
      ;;
  esac
done

shift $(( OPTIND - 1 ))

(( ! ${#repos[@]} )) || [[ -z "${owner_old}" ]] || [[ -z "${owner_new}" ]] && exit 1

# -------------------------------------------------------------------------------------------------------------------- #
# INITIALIZATION.
# -------------------------------------------------------------------------------------------------------------------- #

init() {
  repo_transfer
}

# -------------------------------------------------------------------------------------------------------------------- #
# GITHUB: TRANSFER REPOSITORY.
# -------------------------------------------------------------------------------------------------------------------- #

repo_transfer() {
  for repo in "${repos[@]}"; do
    echo "" && echo "--- OPEN: '${repo}'"

    ${curl} -X POST \
      -H "Authorization: Bearer ${token}" \
      -H "Accept: application/vnd.github+json" \
      "https://api.github.com/repos/${owner_old}/${repo}/transfer" \
      -d "{\"new_owner\":\"${owner_new}\"}"

    echo "" && echo "--- DONE: '${repo}'" && echo ""; sleep ${sleep}
  done
}

# -------------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------------< INIT FUNCTIONS >------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

init "$@"; exit 0
