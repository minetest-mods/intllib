#! /bin/bash

me=$(basename "${BASH_SOURCE[0]}");

if [[ $# -lt 1 ]]; then
	echo "Usage: $me FILE..." >&2;
	exit 1;
fi

mkdir -p locale;
echo "Generating template..." >&2;
xgettext --from-code=UTF-8 \
		--keyword=S \
		--keyword=NS:1,2 \
		--keyword=N_ \
		--add-comments='Translators:' \
		--add-location=file \
		-o locale/template.pot \
		"$@" \
		|| exit;

find locale -name '*.po' -type f | while read -r file; do
	echo "Updating $file..." >&2;
	msgmerge --update "$file" locale/template.pot;
done

echo "DONE!" >&2;
