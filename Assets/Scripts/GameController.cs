using UnityEngine;
using UnityEngine.InputSystem;

public class GameController : MonoBehaviour
{
    public static GameController instance;

    [SerializeField] private InputActionReference actionButton;

    public enum GameSate {StartGame, GoEat, GoSleep, DayTransition, EndGame}

    public GameSate m_GameState = GameSate.StartGame;

    private bool bearTriggerObjective = false;

    private void Awake()
    {
        actionButton.action.performed += _ => Action();
        instance = this;
    }

    private void OnEnable()
    {
        actionButton.action.Enable();
    }

    private void Start()
    {
        ObjectiveInstance.OnPlayerTriggerEnterObjective += OnPlayerTriggerEnterObjective;
        ObjectiveInstance.OnPlayerTriggerExitObjective += OnPlayerTriggerExitObjective;
    }

    private void Action()
    {
        if (m_GameState != GameSate.GoEat && m_GameState != GameSate.GoSleep)  return; 

        if (bearTriggerObjective)
        {
            TimeOfDayHandeler.Instance.Swap();
            PressButtonDisplay.instance.Disable();

            if (m_GameState == GameSate.GoEat)
            {
                m_GameState = GameSate.GoSleep;
            }

            else if (m_GameState == GameSate.GoSleep)
            {
                m_GameState = GameSate.DayTransition;
                DayTransitionManager.instance.InitDayTransition();
            }
            bearTriggerObjective = false;
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
