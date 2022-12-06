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
  -o 'OWNER'                            The organization name. The name is not case sensitive.
  -r 'REPO_1;REPO_2;REPO_3'             The name of the repository (array).
  -d 'DESCRIPTION'                      A short description of the repository.
  -s 'https://example.org/'             Repository site URL.
  -l 'mit'                              Open source license template. For example, "mit" or "mpl-2.0".
  -p                                    Whether the repository is private.
  -i                                    Enable issues for this repository.
  -j                                    Enable projects for this repository.
                                        NOTE: If you're creating a repository in an organization that has disabled
                                        repository projects, the API returns an error.
  -w                                    Enable the wiki for this repository.
  -u                                    Create an initial commit with empty README.
EOF

# -------------------------------------------------------------------------------------------------------------------- #
# OPTIONS.
# -------------------------------------------------------------------------------------------------------------------- #

OPTIND=1

while getopts "x:o:r:d:s:l:pijwuh" opt; do
  case ${opt} in
    x)
      token="${OPTARG}"
      ;;
    o)
      org="${OPTARG}"
      ;;
    r)
      repos="${OPTARG}"; IFS=';' read -ra repos <<< "${repos}"
      ;;
    d)
      description="${OPTARG}"
      ;;
    s)
      homepage="${OPTARG}"
      ;;
    l)
      license="${OPTARG}"
      ;;
    p)
      private=1
      ;;
    i)
      has_issues=1
      ;;
    j)
      has_projects=1
      ;;
    w)
      has_wiki=1
      ;;
    u)
      auto_init=1
      ;;
    h|*)
      echo "${help}"
      exit 2
      ;;
  esac
done

shift $(( OPTIND - 1 ))

(( ! ${#repos[@]} )) || [[ -z "${org}" ]] && exit 1

# -------------------------------------------------------------------------------------------------------------------- #
# INITIALIZATION.
# -------------------------------------------------------------------------------------------------------------------- #

init() {
  repo_create
}

# -------------------------------------------------------------------------------------------------------------------- #
# GITHUB: CREATE REPOSITORY.
# -------------------------------------------------------------------------------------------------------------------- #

repo_create() {
  [[ -n "${private}" ]] && private="true" || private="false"
  [[ -n "${has_issues}" ]] && has_issues="true" || has_issues="false"
  [[ -n "${has_projects}" ]] && has_projects="true" || has_projects="false"
  [[ -n "${has_wiki}" ]] && has_wiki="true" || has_wiki="false"
  [[ -n "${auto_init}" ]] && auto_init="true" || auto_init="false"

  for repo in "${repos[@]}"; do
    echo "" && echo "--- OPEN: '${repo}'"

    ${curl} -X POST \
      -H "Authorization: Bearer ${token}" \
      -H "Accept: application/vnd.github+json" \
      "https://api.github.com/orgs/${org}/repos" \
      -d @- << EOF
{
  "name": "${repo}",
  "description": "${description}",
  "homepage": "${homepage}",
  "private": ${private},
  "has_issues": ${has_issues},
  "has_projects": ${has_projects},
  "has_wiki": ${has_wiki},
  "auto_init": ${auto_init},
  "license_template": "${license}"
}
EOF

    echo "" && echo "--- DONE: '${repo}'" && echo ""; sleep ${sleep}
  done
}

# -------------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------------< INIT FUNCTIONS >------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

init "$@"; exit 0
