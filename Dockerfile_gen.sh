#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}Please enter the language you want to create a docker file for: ${NC}"
name=$(gum input --placeholder "Language name?")

base_image=$(curl -s "https://hub.docker.com/v2/repositories/library/${name}/tags")

if [ "$base_image" = "null" ]; then
  echo "please enter a valid language name!"
  exit 1
fi

base_image=$(curl -s "https://hub.docker.com/v2/repositories/library/${name}/tags" \
  | jq -r '.results[]?.name' \
  | gum choose)

if [ -z "$base_image" ]; then
  echo -e "${RED}No base image selected. Exiting.${NC}"
  exit 1
fi

base_image=${base_image//\"/}
echo "$base_image"




######## add ENV variables and utilize gum with an example.  
env_vars=""
echo -e "${GREEN}Enter environment variables (KEY=VALUE), type 'done' when finished:${NC}"
while true; do
  env_input=$(gum input --placeholder="")
  [[ "$env_input" == "done" || -z "$env_input" ]] && break
  env_vars+="ENV $env_input\n"
done



echo -e "FROM ${name}:${base_image}\nWORKDIR /app\nCOPY . ." > Dockerfile

if [ "$name" = "python" ]; then
  echo "RUN pip install -r requirements.txt" >> Dockerfile
elif [ "$name" = "node" ]; then
  echo "RUN npm install" >> Dockerfile
fi

#print the ENV variables then selecet port
[[ -n "$env_vars" ]] && echo -e "$env_vars" >> Dockerfile
echo "EXPOSE 8080" >> Dockerfile

if [ "$name" = "python" ]; then
  echo 'CMD ["python", "main.py"]' >> Dockerfile
elif [ "$name" = "node" ]; then
  echo 'CMD ["node", "server.js"]' >> Dockerfile
fi

echo -e "${GREEN}Dockerfile created successfully based on ${name}:${base_image}.${NC}"

