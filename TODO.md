# TODO LIST

- Move Icon Library from bridge and use the assets feature on the CLI server to serve Icons or a more advance to reduce loading all large Icon Library once

- Introduce lazy module bundling or resolving for large library, get the list of initial modules needed for cold start, lazy load the new added when hotreloading, remove unused ones from memory when not needed anymore

- Improve stacktrace to include loaded project files traces
