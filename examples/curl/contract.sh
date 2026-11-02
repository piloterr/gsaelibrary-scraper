#!/usr/bin/env bash
# GSA eLibrary Contract API – cURL example
# Usage: PILOTERR_API_KEY=your-key ./contract.sh
set -euo pipefail

curl -sS --fail-with-body -G "https://api.piloterr.com/v2/gsaelibrary/contract" \
  -H "x-api-key: ${PILOTERR_API_KEY}" \
  --data-urlencode 'query=https://www.gsaelibrary.gsa.gov/ElibMain/contractorInfo.do?contractNumber=GS-07F-0239T&contractorName=US+RADAR+INC&executeQuery=YES'
