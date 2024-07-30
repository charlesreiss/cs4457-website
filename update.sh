#eval "$(~/bin/rbenv init -)"
    
umask 022
python3 recordings_to_data.py # XXX
chmod -R a+r files
chmod -R a+r oldquiz
chmod -R a+r readings/files
chmod -R a+r slides
chmod -R a+rX ~/public_html/4457/F2024/recordings

BUNDLE=bundle
$BUNDLE exec jekyll b --trace "${@}"
