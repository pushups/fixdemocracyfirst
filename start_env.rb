commands = {
  postgres: 'postgres -D /usr/local/var/postgres &',
  redis: 'redis-server /usr/local/etc/redis.conf &',
  elasticsearch: 'elasticsearch --config=/usr/local/opt/elasticsearch/config/elasticsearch.yml &'
}
if ARGV[0] == 'start'
  commands.each do |type, command|
    pid = spawn(command)
  end
elsif ARGV[0] == 'stop'
  ['[p]ostgres', '[r]edis-server', '[e]lasticsearch'].each do |service|
    id = `pgrep -f #{service}`
    `kill -s SIGKILL #{id}`
  end
end
