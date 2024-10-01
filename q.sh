#!/bin/bash    
  
set_language() {    
    local lang="${LANG%%@*}"   
    local lang_prefix="${lang%%_*}"     
    
    if [[ "$lang_prefix" == "zh" ]]; then    
        echo_csrutil_disabled="SIP已禁用。"    
        echo_continue_operation="继续下一步操作..."    
        echo_script_exit="脚本退出。"    
        echo_invalid_input="无效的输入，请重试。"    
        echo_open_webpage="打开GitHub仓库"    
        prompt_user_input="输入 y 继续下一步操作，还或者按 q 退出，按 w 打开GitHub仓库: "    
        echo_system_xianz="有一些系统可能无法完全删除，需要你在Finder里找到MRT文件删除（如果没有MRT文件可以跳过）。"  
    else    
        echo_csrutil_disabled="SIP is disabled."    
        echo_continue_operation="Continue..."    
        echo_script_exit="Script exited."    
        echo_invalid_input="Invalid input, please try again."    
        echo_open_webpage="Opening the GitHub Repo..."    
        prompt_user_input="Enter 'y' to continue, 'q' to quit, 'w' to open the GitHub Repo: "    
        echo_system_xianz="Some System doesn't delete the MRT completely, you need to delete it manually. If your Mac didn't have the MRT in that folder, just ignore it."  
    fi    
}
   
if [ "$(id -u)" -ne 0 ]; then  
    echo "$echo_script_exit" 
    exit 1  
fi  
  
set_language  
  

output=$(sudo csrutil status 2>&1 | awk '{print tolower($0)}')  
  
 
if echo "$output" | grep -q 'disabled'; then  
    echo "$echo_csrutil_disabled"  
      

    read -p "$prompt_user_input" user_input  
    user_input=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')  
  

    case "$user_input" in  
        "onlyapplecando"|"onlyapplecan"|"onlyapple"|"y"|"yes")  
            echo "$echo_continue_operation"  
	    Y_S_S=$(pgrep -f YaraScanService)
	    sudo kill -9 $Y_S_S
            sudo launchctl stop com.apple.mrt
            sudo launchctl remove com.apple.mrt
	    M_R_T=$(pgrep -f MRT)
	    sudo kill -9 $M_R_T
            rm     /System/Library/LaunchDaemons/com.apple.mrt.plist
            rm     /System/Library/LaunchDaemons/com.apple.mrtd.plist
	    rm     /System/Library/LaunchAgents/com.apple.MRTa.plist
	    rm     /System/Library/LaunchAgents/com.apple.mrt.uiagent.plist
            rm -rf /System/Library/CoreServices/MRTAgent.app
	    rm -rf /System/Library/CoreServices/MRT.app
            sudo rm /usr/libexec/MRT
	    open /usr/libexec/
	    echo "$echo_system_xianz"
	    osascript -e 'tell app "System Events" to display dialog "empty"'
            ;;  
        "q"|"quit")  
            echo "$echo_script_exit"  
            exit 0  
            ;;  
        "w"|"webpage"|"openwebpage")  
            echo "$echo_open_webpage"  
            open "https://static.marisa.ml/1" 
            ;;  
        *)  
            echo "$echo_invalid_input"  
            exit 1 
            ;;  
    esac  
else  
    echo "$echo_script_exit"  
    exit 1  
fi
