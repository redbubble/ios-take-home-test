#!/bin/bash

FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch -f --env-filter "
    GIT_AUTHOR_NAME='Anonymous Candidate'
    GIT_AUTHOR_EMAIL='anonymous@candidate.com'
    GIT_COMMITTER_NAME='Anonymous Candidate'
    GIT_COMMITTER_EMAIL='anonymous@candidate.com'
  " HEAD
