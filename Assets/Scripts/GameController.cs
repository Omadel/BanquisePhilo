using UnityEngine;

public class GameController : MonoBehaviour
{
    public static GameController instance;

    public enum GameSate {StartGame, GoEat, GoSleep, DayTransition, EndGame}

    public GameSate m_GameState = GameSate.StartGame;

    private bool bearTriggerObjective = false;

    private void Awake()
    {
        instance = this;
    }

    private void Start()
    {
        ObjectiveInstance.OnPlayerTriggerEnterObjective += OnPlayerTriggerEnterObjective;
        ObjectiveInstance.OnPlayerTriggerExitObjective += OnPlayerTriggerExitObjective;
    }

    private void Update()
    {
        if(m_GameState != GameSate.GoEat && m_GameState != GameSate.GoSleep) { return; }

        if (bearTriggerObjective)
        {
            if (Input.GetKeyDown(KeyCode.E))
            {
                TimeOfDayHandeler.Instance.Swap();
                PressButtonDisplay.instance.Disable();

                if (m_GameState == GameSate.GoEat)
                {
                    m_GameState = GameSate.GoSleep;
                }               

                else if(m_GameState == GameSate.GoSleep)
                {
                    m_GameState = GameSate.DayTransition;
                    DayTransitionManager.instance.InitDayTransition();
                }
                bearTriggerObjective = false;
            }
        }
    }

    public void ChangeGameState(GameSate newGameState)
    {
        m_GameState = newGameState;
    }

    private void OnPlayerTriggerEnterObjective(GameObject currObjective)
    {
        if (currObjective == TimeOfDayHandeler.Instance.Objective)
        {
            bearTriggerObjective = true;
            if (m_GameState == GameSate.GoEat)
            {
                PressButtonDisplay.instance.Enable("Eat");
            }
            else if (m_GameState == GameSate.GoSleep)
            {
                PressButtonDisplay.instance.Enable("Sleep");
            }
        }
    }

    private void OnPlayerTriggerExitObjective(GameObject currObjective)
    {
        if (currObjective == TimeOfDayHandeler.Instance.Objective)
        {
            bearTriggerObjective = false;
            PressButtonDisplay.instance.Disable();
        }
    }
}
