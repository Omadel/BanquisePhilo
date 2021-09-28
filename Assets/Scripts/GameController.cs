using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameController : MonoBehaviour
{
    public static GameController instance;

    public enum GameSate {StartGame, GoEat, GoSleep, DayTransition, EndGame}

    public GameSate m_GameState = GameSate.StartGame;

    private void ChangeGameState(GameSate newGameState)
    {
        m_GameState = newGameState;
    }
}
