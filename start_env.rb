
if ARGV[0] == 'start'
    `postgres -D /usr/local/var/postgres & `
    `redis-server /usr/local/etc/redis.conf &`
    `elasticsearch --config=/usr/local/opt/elasticsearch/config/elasticsearch.yml &`
elsif ARGV[0] == 'stop'
['[p]ostgres', '[r]edis-server', '[e]lasticsearch'].each do |service|
id = `pgrep -f #{service}`
`kill -s SIGKILL #{id}`
end
end