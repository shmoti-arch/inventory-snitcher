# by shmoti

source ./lib/ansi

ansi --magenta ".___                           __                          _________ _______  .__  __         .__     "
ansi --magenta "|   | _______  __ ____   _____/  |_  ___________ ___.__.  /   _____/ \      \ |__|/  |_  ____ |  |__  "
ansi --magenta "|   |/    \  \/ // __ \ /    \   __\/  _ \_  __ <   |  |  \_____  \  /   |   \|  \   __\/ ___\|  |  \ "
ansi --magenta "|   |   |  \   /\  ___/|   |  \  | (  <_> )  | \/\___  |  /        \/    |    \  ||  | \  \___|   Y  \ "
ansi --magenta "|___|___|  /\_/  \___  >___|  /__|  \____/|__|   / ____| /_______  /\____|__  /__||__|  \___  >___|  /"

ansi --magenta "                         github.com/shmoti-arch/inventory-snitcher                                    "


ansi --magenta "Choose a number between 1 to 2"

echo "[1] --> Snitch inventory (default-models)"
echo "[2] --> Exit"

keyword=''

choice=''
read -p '--> ' choice

if [ "$choice" = 1 ]; then
    echo 'using api :: https://apis.roblox.com/toolbox-service/v2/assets/search'
    userID=''
    read -p 'enter a UserID --> ' userID
    echo 'checking entered userid...'
    curl -s -X POST "https://users.roblox.com/v1/users" \
      -H "Content-Type: application/json" \
      -d "{\"userIds\":[$userID]}" -o /tmp/response.json
    if grep -q "\"id\":$userID" /tmp/response.json; then
        ansi --green "success!"
        echo "proceeding with username: "  
        jq -r '.data[0].name' /tmp/response.json
    
        clear
        echo "you need to create a Creator Store API to proceed"
        API_KEY=""
        read -p "--> " API_KEY

        echo "making request to toolbox-service API..."
    
        HTTP_CODE=$(curl -w "%{http_code}" -X GET "https://apis.roblox.com/toolbox-service/v2/assets:search?searchCategoryType=Model&userId=$userID" \
             -H "x-api-key: $API_KEY" \
             -H "User-Agent: Roblox/WinInet" \
             -H "Accept: application/json" \
             -o /tmp/responsemodels.json)
    
        echo "status Code: $HTTP_CODE"
    
        if [ "$HTTP_CODE" = "200" ]; then
           echo "API request successful. Response:"
           cat /tmp/responsemodels.json | jq '.' 2>/dev/null || cat /tmp/responsemodels.json
        else
           ansi --red "API request failed. Code: $HTTP_CODE"
           cat /tmp/responsemodels.json
        fi
    
    else
        ansi --red "error! HTTP status: $response"
        cat /tmp/response.json
    fi
elif [ "$choice" = 2 ]; then
     exit 1
fi
