#!/bin/sh

release_ctl eval --mfa "SimplefootballWeb.ReleaseTasks.migrate/1" --argv -- "$@"
