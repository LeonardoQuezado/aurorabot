defmodule Aurorabot.Consumer do
  use Nostrum.Consumer
  alias Nostrum.Api

  def start_link do
    Consumer.start_link(__MODULE__)
  end


  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do

    cond do
    msg.content=="!ping" ->  Api.create_message(msg.channel_id, "Pong!")
    msg.content == "!oi" ->  Api.create_message(msg.channel_id, "Ahoy!")
    msg.content == "!ppt" -> Api.create_message(msg.channel_id, "INvalido usa !ppt pedra ou papel ou tesoura")
    msg.content == "!tempo" -> Api.create_message(msg.channel_id, "INvalido usa !tempo + **nome_da_cidade**")
    msg.content == "!email" -> Api.create_message(msg.channel_id, "INvalido usa ! + **email**")
    msg.content == "!phone" -> Api.create_message(msg.channel_id, "INvalido usa !phone + **numero**")
    msg.content == "!vat" -> Api.create_message(msg.channel_id, "INvalido usa !money + **Moeda a qual deseja saber**")
    msg.content == "!tz" -> Api.create_message(msg.channel_id, "INvalido usa !tz + **nome_da_cidade/estado/pais**")
    String.starts_with?(msg.content, "!ppt ") -> evaluete_ppt(msg)
    String.starts_with?(msg.content, "!tempo ") -> evaluete_wheater(msg)
    String.starts_with?(msg.content, "!email ") -> evaluete_email(msg)
    String.starts_with?(msg.content, "!phone ") -> evaluete_phone(msg)
    String.starts_with?(msg.content, "!vat ") -> evaluete_vat(msg)
    String.starts_with?(msg.content, "!tz ") -> evaluete_tz(msg)
    true -> :ok
  end
  end

  def handle_event(_) do
    :ok
  end

  defp evaluete_tz(msg) do
    aux = String.split(msg.content, " ", parts: 2)
    cidade = Enum.fetch!(aux,1)
    apiKey = "ADDKEY"
    url = "https://timezone.abstractapi.com/v1/current_time/?api_key=#{apiKey}&location=#{cidade}"
    resp = HTTPoison.get!(url)
    json = Poison.decode!(resp.body)
          resultz = json["datetime"]
          Api.create_message(msg.channel_id, "horario na localidade: #{resultz}")
    end

defp evaluete_vat(msg) do
    aux = String.split(msg.content, " ", parts: 2)
    vat = Enum.fetch!(aux,1)
    apiKey = "ADDKEY"
    url = "https://vat.abstractapi.com/v1/validate/?api_key=#{apiKey}&vat_number=#{vat}"
    resp = HTTPoison.get!(url)
    json = Poison.decode!(resp.body)
          resulword = json["company"]["name"]
          Api.create_message(msg.channel_id, "Nome do vat correspondente: #{resulword}")
    end

  def evaluete_phone(msg) do
    aux = String.split(msg.content, " ", parts: 2)
    phone = Enum.fetch!(aux,1)
    apiKey = "ADDKEY"
    url = "https://phonevalidation.abstractapi.com/v1/?api_key=#{apiKey}&phone=#{phone}"
    resp = HTTPoison.get!(url)
    json = Poison.decode!(resp.body)
        tempo = json["country"]["code"]
        Api.create_message(msg.channel_id, "o local  do telefone  #{phone} e #{tempo}")
  end


  defp evaluete_email(msg) do
  aux = String.split(msg.content, " ", parts: 2)
  email = Enum.fetch!(aux,1)
  apiKey = "ADDKEY"
  url = "https://emailvalidation.abstractapi.com/v1/?api_key=#{apiKey}&email=#{email}"
  resp = HTTPoison.get!(url)
  json = Poison.decode!(resp.body)
        mail = json["is_valid_format"]["value"]
        Api.create_message(msg.channel_id, "o fortado do email #{email} e #{mail}")

  end


  defp evaluete_wheater(msg) do

    aux = String.split(msg.content, " ", parts: 2)
    city = Enum.fetch!(aux, 1)
    apiKey = "ADDKEY"
    url = "api.openweathermap.org/data/2.5/weather?q=#{city}&appid=#{apiKey}"


    resp =  HTTPoison.get!(url)

    case resp.status_code do
      200 ->
        json = Poison.decode!(resp.body)
        temp = json["main"]["temp"]
        Api.create_message(msg.channel_id, "a temperatura em #{city} e de #{temp}
        graus")

      400 ->
        Api.create_message(msg.channel_id,"A cidade #{city} não foi encontrada")
    end
  end
def evaluete_ppt(msg) do

  aux = String.split(msg.content)
  if Enum.count(aux) == 2 do
  case Enum.fetch!(aux,1) do
    "pedra" -> evaluate_stone(msg)
    "papel" -> evaluate_paper(msg)
    "tesoura" -> evaluate_scisor(msg)
    _ ->  Api.create_message(msg.channel_id, "INvalido usa !ppt pedra ou papel ou tesoura")
  end
  else
    Api.create_message(msg.channel_id, "INvalido usa !ppt pedra ou papel ou tesoura")
  end
end

defp evaluate_stone(msg) do
  bot_element = Enum.random(0..2)
  case bot_element do
      0 -> Api.create_message(msg.channel_id,"eu escolhi pedra. Empatamos")
      1 -> Api.create_message(msg.channel_id,"eu escolhi papel. ganhei ekekkeke")
      2 -> Api.create_message(msg.channel_id,"eu escolhi tesoura. Perdi! Ladrão!")
  end
end

defp evaluate_paper(msg) do
  bot_element = Enum.random(0..2)
  case bot_element do
      0 -> Api.create_message(msg.channel_id,"eu escolhi pedra. Perdi! Ladrão!")
      1 -> Api.create_message(msg.channel_id,"eu escolhi papel. Empatamos")
      2 -> Api.create_message(msg.channel_id,"eu escolhi tesoura. ganhei ekekkeke")
  end
end

defp evaluate_scisor(msg) do
  bot_element = Enum.random(0..2)
  case bot_element do
      0 -> Api.create_message(msg.channel_id,"eu escolhi pedra. ganhei ekekkeke")
      1 -> Api.create_message(msg.channel_id,"eu escolhi papel. Perdi! Ladrão!")
      2 -> Api.create_message(msg.channel_id,"eu escolhi tesoura. Empatamos")
  end
end
end
