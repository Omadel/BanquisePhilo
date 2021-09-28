using UnityEngine;
using UnityEngine.InputSystem;
using DG.Tweening;

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

    [ContextMenu("Win !")]
    public void WinGame() {
        m_GameState = GameSate.EndGame;
        var cam = Camera.main;
        var cameraTarget = cam.transform.parent;

        cam.farClipPlane = 5000;
        cameraTarget.transform.DODynamicLookAt(new Vector3(0, -500, 0), 5f)
            .SetEase(Ease.InOutSine);
        cameraTarget.transform.DOLocalMoveZ(-3000f, 5f)
            .SetEase(Ease.InOutCubic);

    }
}
