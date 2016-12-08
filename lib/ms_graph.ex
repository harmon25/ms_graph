defmodule MsGraph do


  def me(access_token) do
    %{body: resp} = HTTPoison.get!("https://graph.microsoft.com/v1.0/me", [{"authorization", "Bearer " <> access_token}], [ssl: [{:versions, [:'tlsv1.2']}]])
    Poison.decode!(resp)
  end

  def member_of(access_token) do
    %{body: resp} = HTTPoison.get!("https://graph.microsoft.com/v1.0/me/memberOf", [{"authorization", "Bearer " <> access_token}], [ssl: [{:versions, [:'tlsv1.2']}]])
    IO.inspect resp
    Poison.decode!(resp)
  end

end
