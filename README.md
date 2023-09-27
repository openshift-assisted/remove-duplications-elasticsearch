# OpenSearch Duplicate Document Remover

This project provides a utility to remove duplicate documents from an OpenSearch index. The process involves fetching all documents from a specified OpenSearch index, identifying duplicates based on a unique comparison field, and then proceeding to remove the duplicates.

## Main Logic
1. Setting up the OpenSearch client.
2. Fetching all documents from the specified OpenSearch index.
3. Identifying duplicate documents based on a comparison field.
4. Removing the duplicates if not in dry-run mode or logging the bulk actions if in dry-run mode.

## Usage
To run the script, use the command:

```bash
ES_URL=<elastic-url> ES_USER=<elastic-user> ES_PASSWORD=<elactic-password> ES_INDEX=<elastic-index> DOCUMENT_COMPARISON_FIELD=<comparison-field> remove-duplications-elasticsearch
