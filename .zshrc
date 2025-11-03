# SAO神聖術コマンド (V3 元素拡張版)
# ~/.zshrc または ~/.bashrc にこの内容をコピー＆ペーストしてください。

function system-call() {
  # $1 = コマンドタイプ (generate, list, system など)
  local command_type="$1"
  # shift: $1 を消費し、引数を一つ左にずらす ($2 が新しい $1 になる)
  shift

  case "$command_type" in
    # --- ！！！ generate (生成・操作系) ！！！ ---
    # 構文: generate {quality} element {motion}
    "generate")
      local quality_type="$1" # luminous, acoustic, thermal, aerial, umbral
      local element_type="$2" # "element"
      local motion_type="$3"  # adhere, discharge, burst, または引数

      if [ "$element_type" != "element" ]; then
        echo "Error: Invalid syntax for generate. 'element' keyword missing."
        return
      fi

      if [ "$quality_type" = "luminous" ]; then
        # --- 光素 (Luminous) ---
        case "$motion_type" in
          "adhere")
            osascript -e 'tell application "System Events" to key code 144'
            echo "System Call: Luminous element generated. (Brightness Increased)"
            ;;
          "discharge")
            osascript -e 'tell application "System Events" to key code 145'
            echo "System Call: Luminous element discharged. (Brightness Decreased)"
            ;;
          *)
            echo "Error: Unknown motion-type '$motion_type' for luminous element."
            ;;
        esac
      elif [ "$quality_type" = "acoustic" ]; then
        # --- 音素 (Acoustic) ---
        case "$motion_type" in
          "adhere")
            osascript -e "set volume output volume (output volume of (get volume settings) + 10)"
            echo "System Call: Acoustic element generated. (Volume Increased)"
            ;;
          "discharge")
            osascript -e "set volume output volume (output volume of (get volume settings) - 10)"
            echo "System Call: Acoustic element discharged. (Volume Decreased)"
            ;;
          "burst")
            osascript -e "set volume output muted (not output muted of (get volume settings))"
            echo "System Call: Acoustic element burst. (Mute Toggled)"
            ;;
          *)
            echo "Error: Unknown motion-type '$motion_type' for acoustic element."
            ;;
        esac
      elif [ "$quality_type" = "thermal" ]; then
        # --- 熱素 (Thermal) ---
        echo "System Call: Generating thermal element (Inspecting CPU Load)..."
        top -l 1 -n 10 | head -n 10
      elif [ "$quality_type" = "aerial" ]; then
        # --- 風素 (Aerial) ---
        local target_city="$motion_type"
        if [ -z "$target_city" ]; then
          echo "Error: Target city missing for aerial element. (e.g., ... aerial element Tokyo)"
        else
          echo "System Call: Generating aerial element (Fetching weather for $target_city)..."
          curl "https://wttr.in/$target_city?0&Q&lang=ja"
        fi
      elif [ "$quality_type" = "umbral" ]; then
        # --- 闇素 (Umbral) ---
        if [ "$motion_type" = "burst" ]; then
          echo "System Call: Bursting umbral element (Toggling Dark Mode)..."
          osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to not dark mode'
        else
          echo "Error: Unknown motion-type '$motion_type' for umbral element. Try 'burst'."
        fi
      else
        echo "Error: Unknown quality-type '$quality_type' for generate."
      fi
      ;;

    # --- ！！！ transfer (転移系) ！！！ ---
    # 構文: transfer human durability from self to left
    "transfer")
      # $1=human, $2=durability, $3=from, $4=self, $5=to, $6=left
      if [ "$1" = "human" ] && [ "$2" = "durability" ] && [ "$3" = "from" ] && [ "$5" = "to" ]; then
        local source_obj="$4"
        local target_obj="$6"
        echo "System Call: Transferring durability from '$source_obj' to '$target_obj'..."
        sleep 1
        echo "Error: Durability transfer failed. Target '$target_obj' is not a valid Fluctlight."
      else
        echo "Error: Invalid syntax for transfer."
      fi
      ;;

    # --- system (制御系) ---
    # 構文: system halt
    "system")
      case "$1" in
        "halt")
          echo "System Call: System halting..."
          sleep 2
          pmset sleepnow
          ;;
        *)
          echo "Error: Unknown system command '$1'"
          ;;
      esac
      ;;
    
    # 構文: seal system
    "seal")
      if [ "$1" = "system" ]; then
        echo "System Call: Sealing system..."
        /System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend
      else
        echo "Error: Unknown seal target '$1'"
      fi
      ;;

    # --- read / inspect (情報系) ---
    # 構文: read system status
    "read")
      if [ "$1" = "system" ] && [ "$2" = "status" ]; then
        echo "System Call: Reading system status..."
        echo "Date/Time: $(date)"
        echo "User: $(whoami)"
        pmset -g batt | grep "InternalBattery" -A 1
      else
        echo "Error: Unknown read command."
      fi
      ;;
    # 構文: inspect self / inspect core-protection / inspect system durability
    "inspect")
      case "$1" in
        "self")
          echo "System Call: Inspecting self..."
          echo "User: $(whoami)"
          echo "Shell: $SHELL"
          echo "Hostname: $(hostname)"
          ;;
        "core-protection")
          echo "System Call: Inspecting Core Protection..."
          echo "Status: ACTIVE"
          echo "Integrity: 100%"
          echo "Note: Removal is highly restricted."
          ;;
        "system")
          # --- 天命調査 (Durability) ---
          if [ "$2" = "durability" ]; then
            echo "System Call: Inspecting system durability (Battery Health)..."
            system_profiler SPPowerDataType | grep "Condition\|Maximum Capacity"
          else
            echo "Error: Unknown inspect target '$1 $2'"
          fi
          ;;
        *)
          echo "Error: Unknown inspect command '$1'"
          ;;
      esac
      ;;

    # --- list (一覧系) ---
    # 構文: list all units / list all spells など
    "list")
      local scope="$1" # all, sacred, system
      local target="$2" # units, residents, spells, tools, connections

      if [ "$scope" = "sacred" ]; then
        target="tools"
      elif [ "$scope" = "system" ]; then
        target="connections"
      fi

      case "$target" in
        "units")
          echo "System Call: Listing all active units (Processes)..."
          ps aux
          ;;
        "residents")
          echo "System Call: Listing all registered residents (Users)..."
          ls /Users
          ;;
        "tools")
          echo "System Call: Listing all sacred tools (Applications)..."
          ls /Applications
          ;;
        "connections")
          echo "System Call: Listing all system connections (Network)..."
          netstat -an
          ;;
        "spells")
          echo "System Call: Listing all registered spells..."
          echo ""
          echo "--- Generate (Element) ---"
          echo "  generate luminous element adhere         (Brightness Up)"
          echo "  generate luminous element discharge      (Brightness Down)"
          echo "  generate acoustic element adhere         (Volume Up)"
          echo "  generate acoustic element discharge      (Volume Down)"
          echo "  generate acoustic element burst          (Toggle Mute)"
          echo "  generate thermal element                 (Show CPU Load)"
          echo "  generate aerial element [City]           (Show Weather)"
          echo "  generate umbral element burst            (Toggle Dark Mode)"
          echo ""
          echo "--- Transfer (Durability) ---"
          echo "  transfer human durability from [A] to [B] (Joke)"
          echo ""
          echo "--- System Control ---"
          echo "  system halt                              (Sleep Mac)"
          echo "  seal system                              (Lock Screen)"
          echo ""
          echo "--- Inspect (Info) ---"
          echo "  read system status                       (Show Date, User, Battery)"
          echo "  inspect self                             (Show User, Shell, Host)"
          echo "  inspect system durability                (Show Battery Health)"
          echo ""
          echo "--- List (Admin) ---"
          echo "  list all units                           (List all processes)"
          echo "  list all residents                       (List users)"
          echo "  list sacred tools                        (List applications)"
          echo "  list system connections                  (List network connections)"
          echo ""
          echo "--- Network ---"
          echo "  search thermal element [target]          (Ping target)"
          echo ""
          echo "--- Core Protection (Joke) ---"
          echo "  inspect core-protection                  (Show status)"
          echo "  remove core-protection                   (Access Denied)"
          echo ""
          echo "--- Help & License ---"
          echo "  list all spells                          (Show this list)"
          echo "  show license                             (Show RATH License)"
          ;;
        *)
          echo "Error: Unknown list target '$target'"
          ;;
      esac
      ;;

    # --- search (探索系) ---
    # 構文: search thermal element [target]
    "search")
      if [ "$1" = "thermal" ] && [ "$2" = "element" ]; then
        local target="$3"
        if [ -z "$target" ]; then
          echo "Error: Search target missing."
        else
          echo "System Call: Searching thermal signature of '$target'..."
          ping -c 4 "$target"
        fi
      else
        echo "Error: Invalid search syntax."
      fi
      ;;
    
    # --- remove (削除系) ---
    # 構文: remove core-protection
    "remove")
      if [ "$1" = "core-protection" ]; then
        echo "System Call: Access Denied."
        echo "Error: Priority level insufficient for core-protection modification."
      else
        echo "Error: Invalid remove syntax."
      fi
      ;;

    # --- show (表示系) ---
    # 構文: show license
    "show")
      if [ "$1" = "license" ]; then
        echo "System Call: Displaying Authority License..."
        sleep 1
        cat << 'EOF'
# 8888888b.         d8888 88888888888 888    888 #
# 888   Y88b       d88888     888     888    888 #
# 888    888      d88P888     888     888    888 #
# 888   d88P     d88P 888     888     8888888888 #
# 8888888P"     d88P  888     888     888    888 #
# 888 T88b     d88P   888     888     888    888 #
# 888  T88b   d8888888888     888     888    888 #
# 888   T88b d88P     888     888     888    888 #
EOF
        echo ""
        echo "PROPERTY OF RATH"
        echo "PROJECT ALICIZATION - Soul Translation Technology Division"
        echo "AUTHORIZED PERSONNEL ONLY"
        echo ""
        echo "This system provides access to the Main Visualizer and Fluctlight Manipulation Interface."
        echo "Unauthorized access, modification, or replication of Fluctlight data is strictly prohibited."
        echo "System Authority Level: 7"
      else
        echo "Error: Invalid show syntax."
      fi
      ;;

    *)
      # コマンドタイプが不明
      echo "Error: Unknown system call '$command_type'"
      echo "Try 'system-call list all spells' for help."
      ;;
  esac
}
