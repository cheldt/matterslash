defmodule Mattslasher.SlashCommand do
  defstruct [
    response_url: "",
    text:         "", 
    token:        "",
    channel_id:   "",
    team_id:      "",
    command:      "",
    team_domain:  "",
    user_name:    "",
    channel_name: "",
  ]
end
