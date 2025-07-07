$domains = @(
    "google.com", "youtube.com", "facebook.com", "twitter.com", "instagram.com",
    "wikipedia.org", "amazon.com", "reddit.com", "linkedin.com", "netflix.com",
    "microsoft.com", "apple.com", "whatsapp.com", "spotify.com", "pinterest.com",
    "yahoo.com", "bing.com", "zoom.us", "github.com", "stackoverflow.com",
    "nytimes.com", "cnn.com", "bbc.com", "quora.com", "twitch.tv",
    "dropbox.com", "paypal.com", "wordpress.com", "tumblr.com", "etsy.com",
    "airbnb.com", "booking.com", "udemy.com", "coursera.org", "khanacademy.org",
    "stackoverflow.com", "duckduckgo.com", "gutenberg.org", "nih.gov", "nasa.gov",
    "bloomberg.com", "forbes.com", "hackernews.com", "cloudflare.com", "openai.com",
    "mozilla.org", "ubuntu.com", "archlinux.org", "npmjs.com", "rust-lang.org"
)

$dnsServers = @{
    "Local"      = $null
    "Cloudflare" = "1.1.1.1"
    "Google"     = "8.8.8.8"
    "Quad9"      = "9.9.9.9"
    "OpenDNS"    = "208.67.222.222"
}

# Results array
$results = @()

# Run the test
foreach ($domain in $domains) {
    foreach ($label in $dnsServers.Keys) {
        $server = $dnsServers[$label]
        try {
            $elapsed = (Measure-Command {
                if ($server) {
                    Resolve-DnsName -Name $domain -Type A -Server $server -ErrorAction Stop | Out-Null
                } else {
                    Resolve-DnsName -Name $domain -Type A -ErrorAction Stop | Out-Null
                }
            }).TotalMilliseconds
            $results += [pscustomobject]@{
                Domain = $domain
                Server = $label
                LatencyMS = "{0:N2}" -f $elapsed
            }
        } catch {
            $results += [pscustomobject]@{
                Domain = $domain
                Server = $label
                LatencyMS = "FAIL"
            }
        }
    }
}

# Display as table
$results | Format-Table -AutoSize

# Optional: Export to CSV
# $results | Export-Csv -Path "dns_latency_results.csv" -NoTypeInformation
