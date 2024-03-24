# docker-dehydrated-cloudflare-cron

Runs [dehydrated-io/dehydrated](https://github.com/dehydrated-io/dehydrated) with [walcony/letsencrypt-cloudflare-hook](https://github.com/walcony/letsencrypt-cloudflare-hook) as a cron job to acquire and update [Let’s Encrypt](https://letsencrypt.org/) certificates by DNS-01 challenge using [CloudFlare](https://www.cloudflare.com/) as the DNS provider.

For using with single domain:
```
docker create \
  --name=dehydrated \
  -e 'CF_EMAIL=email@domain.tld' \
  -e 'CF_KEY=API_key' \
  -e 'CF_HOST=host.domain.tld' \
  -v /path/to/certs:/dehydrated/certs \
  kjake/dehydrated-cloudflare-cron
```
It is possible to generate one certificate containing alternative domains without resorting to creating `domains.txt` in the following manner:
```
-e 'CF_HOST=host1.domain.tld -d host2.domain.tld -d host3.domain.tld' \
```

For use with multiple domains and certificates, provide a [domains.txt](https://github.com/dehydrated-io/dehydrated/blob/master/docs/domains_txt.md) instead, `CF_HOST` environment variable needs to be unset or empty for this to work:
```
docker create \
  --name=dehydrated \
  -e 'CF_EMAIL=email@domain.tld' \
  -e 'CF_KEY=API_key' \
  -v /path/to/domains.txt:/dehydrated/domains.txt:ro \
  -v /path/to/certs:/dehydrated/certs \
  kjake/dehydrated-cloudflare-cron
```

Then start container, which will run update script once at start and once daily after that:
```
docker start dehydrated
```

Based on [kmlucy/docker-dehydrated](https://github.com/kmlucy/docker-dehydrated)