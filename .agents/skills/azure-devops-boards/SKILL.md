---
name: azure-devops-boards
description: >
  Interact with Azure DevOps Boards: read epics, user stories, tasks, bugs and
  other work items; list children/related items; update fields; create work
  items; run WIQL queries. Use when the user shares an Azure DevOps work-item
  URL or asks about ADO boards, epics, sprints, or work items.
allowed-tools: Bash
---

# Azure DevOps Boards Skill

Use the `az boards` CLI (azure-devops extension) — already installed and
authenticated via `az login`. No tokens or curl needed.

---

## 1. Default configuration

Set org and project defaults once per session to avoid repeating `--org` and
`--project` on every command:

```bash
az devops configure -d \
  organization=https://dev.azure.com/pwc-us-adv-digital \
  project="Managed Services Agentic AI"
```

Parse these from a work-item URL when the user provides one:

```bash
URL="https://dev.azure.com/pwc-us-adv-digital/Managed%20Services%20Agentic%20AI/_workitems/edit/1467057"

ORG_NAME=$(echo "$URL" | sed 's|https://dev.azure.com/||' | cut -d'/' -f1)
PROJECT_ENC=$(echo "$URL" | sed 's|https://dev.azure.com/||' | cut -d'/' -f2)
PROJECT=$(python3 -c "import urllib.parse,sys; print(urllib.parse.unquote(sys.argv[1]))" "$PROJECT_ENC")
WORK_ITEM_ID=$(echo "$URL" | grep -oE '[0-9]+$')
ORG="https://dev.azure.com/$ORG_NAME"

az devops configure -d organization="$ORG" project="$PROJECT"
```

### If `az boards` commands fail with auth errors

```bash
az logout
az login --tenant "513294a0-3e20-41b2-a970-6d30bf1546fa"
```

---

## 2. Core operations

### 2.1 Read a work item

```bash
az boards work-item show --id 1467057 --output json
```

To display a clean summary, pipe through python3:

```bash
az boards work-item show --id 1467057 --output json | python3 -c "
import json, sys, html, re

def strip_html(s):
    if not s: return '—'
    return html.unescape(re.sub(r'<[^>]+>', ' ', s)).strip()

data = json.load(sys.stdin)
f = data['fields']
assigned = f.get('System.AssignedTo', {})
if isinstance(assigned, dict): assigned = assigned.get('displayName', '—')

print(f\"## [{f.get('System.WorkItemType','?')} #{data['id']}] {f.get('System.Title','')}\")
print(f\"- State:       {f.get('System.State','—')}\")
print(f\"- Assigned to: {assigned}\")
print(f\"- Area:        {f.get('System.AreaPath','—')}\")
print(f\"- Iteration:   {f.get('System.IterationPath','—')}\")
print(f\"- Priority:    {f.get('Microsoft.VSTS.Common.Priority','—')}\")
print(f\"- Story Points:{f.get('Microsoft.VSTS.Scheduling.StoryPoints','—')}\")
print(f\"- Tags:        {f.get('System.Tags','—')}\")
print()
print('### Description')
print(strip_html(f.get('System.Description','')))
"
```

### 2.2 Read child work items

```bash
# Get relations with friendly names (shows child IDs)
az boards work-item relation show --id 1467057 --output json | python3 -c "
import json, sys
data = json.load(sys.stdin)
children = [r for r in data.get('relations', [])
            if 'Hierarchy-Forward' in r.get('rel','') or r.get('relName','') == 'Child']
print(f'Children ({len(children)}):')
for c in children:
    wid = c['url'].rstrip('/').split('/')[-1]
    print(f'  #{wid}')
"

# Then batch-show all children (replace IDs with actual values)
for ID in 1518722 1486042 1521451; do
  az boards work-item show --id $ID \
    --fields System.Id,System.WorkItemType,System.Title,System.State \
    --output json | python3 -c "
import json,sys
f=json.load(sys.stdin)['fields']
print(f\"{f['System.Id']}\t{f['System.WorkItemType']}\t{f['System.State']}\t{f['System.Title']}\")
"
done
```

### 2.3 Query work items (WIQL)

```bash
az boards query --wiql "
  SELECT [System.Id],[System.WorkItemType],[System.Title],[System.State]
  FROM WorkItems
  WHERE [System.TeamProject] = @project
    AND [System.WorkItemType] IN ('Epic','Feature','User Story','Task','Bug')
  ORDER BY [System.ChangedDate] DESC
" --output table
```

### 2.4 Update a work item

```bash
# Update state
az boards work-item update --id 1467057 --state "Active"

# Update title and assignee
az boards work-item update --id 1467057 \
  --title "New title" \
  --assigned-to "adam.korba@pwc.com"

# Update custom fields (space-separated field=value pairs)
az boards work-item update --id 1467057 \
  --fields "Microsoft.VSTS.Scheduling.StoryPoints=8" "Microsoft.VSTS.Common.Priority=1"
```

### 2.5 Create a work item

```bash
# Basic creation
az boards work-item create \
  --type "User Story" \
  --title "My new story" \
  --description "Details here" \
  --assigned-to "adam.korba@pwc.com" \
  --state "New"

# Then link to a parent epic
az boards work-item relation add \
  --id <new-item-id> \
  --relation-type "parent" \
  --target-id 1467057
```

### 2.6 Add/remove relations

```bash
# List available relation types
az boards work-item relation list-type --output table

# Add a parent link
az boards work-item relation add \
  --id 1518722 \
  --relation-type "parent" \
  --target-id 1467057

# Remove a relation
az boards work-item relation remove \
  --id 1518722 \
  --relation-type "parent" \
  --target-id 1467057 \
  --yes
```

---

## 3. Presenting work items to the user

Always render a clean human-readable summary, not raw JSON:

```
## [Epic #1467057] AI for BI

- **State:** New
- **Assigned to:** Dominika Nadia Wojtczak (PL)
- **Area:** Managed Services Agentic AI\Norfolk Southern Pod
- **Iteration:** Managed Services Agentic AI
- **Priority:** 2
- **Story Points:** —
- **Tags:** —

### Description
A centralized, AI-driven governance engine for the entire Managed Services practice...

### Children (18)
| ID      | Type    | Title                        | State  |
|---------|---------|------------------------------|--------|
| 1518722 | Feature | Onboarding workflow          | Active |
| ...     | ...     | ...                          | ...    |
```

---

## 4. Workflow

1. **Parse** org, project, and work-item ID from the URL (§1).
2. **Set defaults** with `az devops configure` so subsequent commands are concise.
3. **Fetch** the work item with `az boards work-item show`.
4. **Display** a clean summary.
5. **Drill into children** or perform updates/creation as requested.

---

## 5. Error handling

| Error                        | Cause                              | Fix                                  |
|------------------------------|------------------------------------|--------------------------------------|
| `az: command not found`      | CLI not installed                  | `brew install azure-cli`             |
| Auth / 401 errors            | Session expired                    | `az logout && az login`              |
| `ResourceNotFound`           | Wrong ID, org, or project          | Re-check URL parsing                 |
| Extension missing            | azure-devops ext not installed     | `az extension add --name azure-devops` |
