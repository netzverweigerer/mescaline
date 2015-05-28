#!/bin/bash

cat mescaline | \
sed 's/PATH_BG/path_bg/g;s/PATH_FG/path_fg/g;s/CWD_FG/cwd_fg/g;s/SEPARATOR_FG/separator_fg/g;s/REPO_CLEAN_BG/repo_clean_bg/g;s/REPO_CLEAN_FG/repo_clean_fg/g;s/REPO_DIRTY_BG/repo_dirty_bg/g;s/REPO_DIRTY_FG/repo_dirty_fg/g;s/CMD_PASSED_BG/cmd_passed_bg/g;s/CMD_PASSED_FG/cmd_passed_fg/g;s/CMD_FAILED_BG/cmd_failed_bg/g;s/CMD_FAILED_FG/cmd_failed_fg/g;s/SVN_CHANGES_BG/svn_changes_bg/g;s/SVN_CHANGES_FG/svn_changes_fg/g;s/VIRTUAL_ENV_BG/virtual_env_bg/g;s/VIRTUAL_ENV_FG/virtual_env_fg/g'





