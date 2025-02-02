ifndef PDSHOST
PDSHOST=https://bsky.social
endif

ifndef BLUESKY_HANDLE
BLUESKY_HANDLE=ggvy.cl
endif

ifndef HASH
HASH=master
endif

URL=https://github.com/UofUEpiBio/PHS-7045-egga/

# See https://docs.bsky.app/docs/get-started
login:
	curl -X POST $(PDSHOST)/xrpc/com.atproto.server.createSession \
		-H "Content-Type: application/json" \
		-d '{"identifier": "'"$(BLUESKY_HANDLE)"'", "password": "'"$(PASS)"'"}' | jq -r .accessJwt > session.json

write_post:
	echo "Hello gente! Here is a list of the latest papers" > post.txt && \
	echo "About ABMs in PubMed 🤖: $(URL)." >> post.txt && \
	echo "(posted via GitHubActions)!" >> post.txt

post: write_post
	curl -X POST $(PDSHOST)/xrpc/com.atproto.repo.createRecord \
		-H "Authorization: Bearer $(shell cat session.json)" \
		-H "Content-Type: application/json" \
		-d "{\"repo\": \"$(BLUESKY_HANDLE)\", \"collection\": \"app.bsky.feed.post\", \"record\": {\"text\": \"$(shell cat post.txt)\", \"createdAt\": \"$(shell date -u +%Y-%m-%dT%H:%M:%SZ)\", \"facets\": [{\"index\": {\"byteStart\": 76, \"byteEnd\": 121}, \"features\": [{\"$$``type\": \"app.bsky.richtext.facet#link\", \"uri\": \"$(URL)/blob/$(HASH)/README.md\"}]}]}}"
