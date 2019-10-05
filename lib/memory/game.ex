defmodule Memory.Game do

def new do
{randomized, status} = assignValues()
  %{
    alphabets: randomized,
    indisplay: [],
    finished: [],
    visibilityStatus: status,
    numOfClicks: 0,
  }
end

def client_view(game) do
  %{
    alphabets: game.alphabets,
    indisplay: game.indisplay,
    finished:  game.finished,
    visibilityStatus: game.visibilityStatus,
    numOfClicks: game.numOfClicks,
  }
end

def assignValues() do
  initialLetters = ["A","A","B","B","C","C","D","D","E","E","F","F","G","G","H","H"]
  status=["hide","hide","hide","hide",
          "hide","hide","hide","hide",
          "hide","hide","hide","hide",
          "hide","hide","hide","hide"]
  {Enum.shuffle(initialLetters),status}
  end

def onClick(game,bid) do

  {id,""}=Integer.parse(bid)
    if length(game.indisplay) < 2 do

      indisp = game.indisplay ++ [id]
      status = List.replace_at(game.visibilityStatus,id, "show")
      moves = game.numOfClicks + 1
      game = game |>  Map.put(:numOfClicks,moves) |> Map.put(:indisplay,indisp) |> Map.put(:visibilityStatus, status)

      game = game
      game
    else
      game
    end
end

def onClick2(game,bid) do
  if length(game.indisplay) == 2 do
    index1 = Enum.at(game.indisplay,0)
    index2 = Enum.at(game.indisplay,1)
    if Enum.at(game.alphabets,index1) == Enum.at(game.alphabets,index2) do
        complete = game.finished ++ game.indisplay
        indisp=Enum.drop(game.indisplay,2)
        game = game |> Map.put(:finished,complete) |>Map.put(:indisplay,indisp)
        game = game
        game
    else
      Process.sleep(1000)
      status1 = List.replace_at(game.visibilityStatus,index1,"hide")
      status2 = List.replace_at(status1,index2,"hide")
      indisp=Enum.drop(game.indisplay,2)
      game = game |>Map.put(:indisplay,indisp) |>Map.put(:visibilityStatus,status2)
      game=game
      game
    end
 else
  game
end
end

def onHandleReset(game) do
  game.new()
  end
end
