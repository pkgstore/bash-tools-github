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
  -o 'OWNER'                            Repository owner (organization).
  -r 'REPO_1;REPO_2;REPO_3'             Repository name array.
  -t 'TOPIC_1;TOPIC_2;TOPIC_3'          Topic name array.
EOF

# -------------------------------------------------------------------------------------------------------------------- #
# OPTIONS.
# -------------------------------------------------------------------------------------------------------------------- #

OPTIND=1

while getopts "x:o:r:t:h" opt; do
  case ${opt} in
    x)
      token="${OPTARG}"
      ;;
    o)
      owner="${OPTARG}"
      ;;
    r)
      repos="${OPTARG}"; IFS=';' read -ra repos <<< "${repos}"
      ;;
    t)
      topics="${OPTARG}"; IFS=';' read -ra topics <<< "${topics}"
      ;;
    h|*)
      echo "${help}"
      exit 2
      ;;
  esac
done

shift $(( OPTIND - 1 ))

(( ! ${#repos[@]} )) && exit 1

# -------------------------------------------------------------------------------------------------------------------- #
# INITIALIZATION.
# -------------------------------------------------------------------------------------------------------------------- #

init() {
  # Run.
  repo_topics
}

# -------------------------------------------------------------------------------------------------------------------- #
# GITHUB: REPOSITORY TOPICS.
# -------------------------------------------------------------------------------------------------------------------- #

repo_topics() {
  topic=$( printf ',"%s"' "${topics[@]}" )

  for repo in "${repos[@]}"; do
    echo "" && echo "--- OPEN: '${repo}'"

    ${curl} -X PUT \
      -H "Authorization: token ${token}" \
      -H "Accept: application/vnd.github.mercy-preview+json" \
      "https://api.github.com/repos/${owner}/${repo}/topics" \
      -d @- << EOF
{
  "names": [ ${topic:1} ]
}
EOF

    echo "" && echo "--- DONE: '${repo}'" && echo ""

    sleep ${sleep}
  done
}

# -------------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------------< INIT FUNCTIONS >------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

init "$@"; exit 0
