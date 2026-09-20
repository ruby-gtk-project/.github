#!/usr/bin/env bash
# Put the binding issues on the Bindings board, with their fields set.
#
# This is deliberately not the agent's job. Adding an item to a project is
# mechanical, and routing it through safe outputs cost two things that made it
# never work: a deduplicated issue registers no temporary id, so update_project
# had nothing to attach to on any run after the first, and the per-run safe
# output budget is shared, so 35 issues plus 35 board updates blew past it.
#
# Doing it here instead is idempotent (addProjectV2ItemById returns the
# existing item), costs no model credits, and works the same on run one and
# run fifty.
#
# Usage: project-sync.sh <org> <project-number> <repo> <gaps.json> <min-apps>
set -euo pipefail

ORG=$1
NUM=$2
REPO=$3
GAPS=$4
MIN=$5
: "${GITHUB_TOKEN:?project token must be set}"
export GH_TOKEN="$GITHUB_TOKEN"

PID=$(gh api graphql -f query='
  query($o:String!,$n:Int!){ organization(login:$o){ projectV2(number:$n){ id } } }' \
  -f o="$ORG" -F n="$NUM" --jq '.data.organization.projectV2.id')

# Field ids, and the option id behind Status=Todo. Looked up rather than
# hardcoded so renaming a field in the UI does not silently stop the sync.
gh api graphql -f query='
  query($p:ID!){ node(id:$p){ ... on ProjectV2 { fields(first:30){ nodes {
    ... on ProjectV2FieldCommon { id name }
    ... on ProjectV2SingleSelectField { id name options { id name } } } } } } }' \
  -f p="$PID" > /tmp/fields.json

fid() { jq -r --arg n "$1" '.data.node.fields.nodes[]|select(.name==$n)|.id' /tmp/fields.json; }
F_STATUS=$(fid Status)
F_APPS=$(fid "Apps blocked")
F_NS=$(fid Namespace)
O_TODO=$(jq -r '.data.node.fields.nodes[]|select(.name=="Status")|.options[]|select(.name=="Todo")|.id' /tmp/fields.json)

for v in "$F_STATUS" "$F_APPS" "$F_NS" "$O_TODO"; do
  [ -n "$v" ] && [ "$v" != "null" ] || { echo "::error::project $NUM is missing a field the sync needs (Status/Todo, Apps blocked, Namespace)"; exit 1; }
done

# Issue titles carry the namespace, which is how a gap is matched to its issue.
gh issue list --repo "$REPO" --label binding --state open --limit 200 \
  --json number,id,title > /tmp/issues.json

added=0 skipped=0
while IFS=$'\t' read -r ns count; do
  row=$(jq -r --arg t "[binding] ${ns}: Ruby binding needed" \
    '.[]|select(.title==$t)|"\(.id)\t\(.number)"' /tmp/issues.json | head -1)
  if [ -z "$row" ]; then
    echo "  no issue yet for $ns"; skipped=$((skipped+1)); continue
  fi
  gid=${row%%$'\t'*}

  item=$(gh api graphql -f query='
    mutation($p:ID!,$c:ID!){ addProjectV2ItemById(input:{projectId:$p,contentId:$c}){ item { id } } }' \
    -f p="$PID" -f c="$gid" --jq '.data.addProjectV2ItemById.item.id')

  gh api graphql -f query='
    mutation($p:ID!,$i:ID!,$f:ID!,$v:String!){ updateProjectV2ItemFieldValue(
      input:{projectId:$p,itemId:$i,fieldId:$f,value:{singleSelectOptionId:$v}}){ clientMutationId } }' \
    -f p="$PID" -f i="$item" -f f="$F_STATUS" -f v="$O_TODO" >/dev/null
  gh api graphql -f query='
    mutation($p:ID!,$i:ID!,$f:ID!,$v:Float!){ updateProjectV2ItemFieldValue(
      input:{projectId:$p,itemId:$i,fieldId:$f,value:{number:$v}}){ clientMutationId } }' \
    -f p="$PID" -f i="$item" -f f="$F_APPS" -F v="$count" >/dev/null
  gh api graphql -f query='
    mutation($p:ID!,$i:ID!,$f:ID!,$v:String!){ updateProjectV2ItemFieldValue(
      input:{projectId:$p,itemId:$i,fieldId:$f,value:{text:$v}}){ clientMutationId } }' \
    -f p="$PID" -f i="$item" -f f="$F_NS" -f v="$ns" >/dev/null

  added=$((added+1))
done < <(jq -r --argjson min "$MIN" '.gaps[]|select(.app_count>=$min)|"\(.namespace)\t\(.app_count)"' "$GAPS")

echo "board: $added items synced, $skipped gaps with no issue yet"
