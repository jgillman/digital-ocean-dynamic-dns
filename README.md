A dependency free bash script to dynamically update your DNS on DigitalOcean.

~~Stolen from~~ _Inspired by_ Nicu Surdu's post: https://surdu.me/2019/07/28/digital-ocean-ddns.html

I wanted a dynamic DNS updater that I could control. There are a LOT of scripts out there that do it written in PHP, Python, Go, Perl, Node, etc. I couldn't find one (other than Nicu's) that could just run in bash with cURL.

# Links

You can create a DigitalOcean personal access token here: https://cloud.digitalocean.com/account/api/tokens

# Install

Copy `secrets.example` to `secrets` and fill in your info.

The "record IDs" can be found after putting in your access token and domain, then run `./get-dns.sh` to output all of the records for that domain. Copy and paste the record(s) into the array (separated with spaces if you have more than one you want to update).

Once you've filled in all of the info in ./secrets you can run `./update-dns.sh` which will find your current public IP, compare it to the current DNS record, and update the DNS record if the IP has changed.

# Run it on the reg

You can set it up to run at whatever interval you prefer. cron is an easy choice:

```
# Every 30 minutes on the hour and half hour
*/30 * * * * /path/to/update-dns.sh >/dev/null 2>&1

# Every hour on the hour
0 * * * * /path/to/update-dns.sh >/dev/null 2>&1
```

Personally I like using services so I'll probably write up one of those in the future.

# Contributing

If you have any additions I'd love to see them! Open a PR or an Issue.
