defmodule Mattslasher.SlashCommand do
  @moduledoc false

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

  @type t :: %__MODULE__{
    response_url: String.t,
    text:         String.t,
    token:        String.t,
    channel_id:   String.t,
    team_id:      String.t,
    command:      String.t,
    team_domain:  String.t,
    user_name:    String.t,
    channel_name: String.t,
  }
end
