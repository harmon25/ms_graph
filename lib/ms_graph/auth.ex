defmodule MsGraph.OAuth do
    @auth_url "https://login.microsoftonline.com/common/oauth2/authorize"
    @token_url "https://login.microsoftonline.com/common/oauth2/token"

    def auth_url(params \\ []) do
        scopes = ["user.read","user.readbasic.all","tasks.read","calendars.read"]
        query = URI.encode_query([{"client_id", Application.get_env(:ms_graph, :client_id) }, {"response_type", "code"}, {"redirect_uri", Application.get_env(:ms_graph, :redirect_uri)}, {"scope", Enum.join(scopes, " ")}] ++ params)
        @auth_url <> "?" <> query
    end

    def get_token!(access_code) do
        body =
        [{:grant_type, "authorization_code"},
        {:client_id, Application.get_env(:ms_graph, :client_id)},
        {:redirect_uri, Application.get_env(:ms_graph, :redirect_uri)},
        {:client_secret, Application.get_env(:ms_graph, :client_secret)},
        {:resource, "https://graph.microsoft.com/"},
        {:code, access_code}]
        |> URI.encode_query

        headers = [{"content-type", "application/x-www-form-urlencoded"}]
        case(HTTPoison.post(@token_url, body, headers, [ssl: [{:versions, [:'tlsv1.2']}]])) do
          {:ok, resp} ->
              {:ok, Poison.decode!(resp.body)}
             _ ->
              {:error, "bad token"}
         end
      end
end
