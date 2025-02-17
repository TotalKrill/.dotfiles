#!sh
git commit -am "`git diff -- ':!*.lock' | sc commit`"
