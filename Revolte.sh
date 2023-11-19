apt-get update
apt-get install lynx -y
apt-get install htop -y
apt-get install apache2-utils -y
apt-get install jq -y

echo '
{
  "username": "kelompokIT21",
  "password": "passwordIT21"
}' > register.json

echo '
{
  "username": "kelompokIT21",
  "password": "passwordIT21"
}' > login.json

curl -X POST -H "Content-Type: application/json" -d @login.json http://10.74.4.6:8001/api/auth/login > login_output.txt

token=$(cat login_output.txt | jq -r '.token')

# Command Testing
# ab -n 100 -c 10 -p register.json -T application/json http://10.74.4.6:8001/api/auth/register
# ab -n 100 -c 10 -p login.json -T application/json http://10.74.4.6:8001/api/auth/login
# ab -n 100 -c 10 -H "Authorization: Bearer $token" http://10.74.4.6:8001/api/me
# ab -n 100 -c 10 -p login.json -T application/json http://www.riegel.canyon.it21.com/api/auth/login