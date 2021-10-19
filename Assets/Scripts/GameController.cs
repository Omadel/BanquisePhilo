using DG.Tweening;
using System.Collections;
using UnityEngine;
using UnityEngine.InputSystem;

public class GameController : MonoBehaviour {
    public static GameController instance;

    [SerializeField] private InputActionReference actionButton;
    [SerializeField] private GameObject[] maps;
    [SerializeField] private GameObject bear;

    public enum GameSate { GoEat, GoSleep, DayTransition, EndGame }

    public GameSate m_GameState = GameSate.DayTransition;

    private bool bearTriggerObjective = false;

    public CMF.SimpleWalkerController bearController;

    private bool a = false;

    private void Awake()
    {
        actionButton.action.performed += _ => Action();
        instance = this;
    }

    private void OnEnable() {
        actionButton.action.Enable();
    }

    private void Start() {
        ObjectiveInstance.OnPlayerTriggerEnterObjective += OnPlayerTriggerEnterObjective;
        ObjectiveInstance.OnPlayerTriggerExitObjective += OnPlayerTriggerExitObjective;
    }

    private void Update()
    {
        if(bearController.enabled == true)
        {
            if(m_GameState == GameSate.DayTransition)
            {
                bearController.enabled = false;
            }
        }
        else
        {
            if(m_GameState != GameSate.DayTransition)
            {
                bearController.enabled = true;
            }
        }

        if (a)
        {
            bear.transform.position = new Vector3(0f, -320f, 0f);
        }
    }

    private void Action()
    {
        if (m_GameState != GameSate.GoEat && m_GameState != GameSate.GoSleep)  return; 

        if(bearTriggerObjective) {
            PressButtonDisplay.instance.Disable();

            if(m_GameState == GameSate.GoEat) {
                TimeOfDayHandeler.Instance.Swap();
                m_GameState = GameSate.GoSleep;
            } else if(m_GameState == GameSate.GoSleep) {
                if(DayTransitionManager.instance.dayIndex == DayTransitionManager.instance.dayTexts.Length) {
                    bear.GetComponent<Rigidbody>().velocity = Vector3.zero;
                    WinGame();
                } else {
                    m_GameState = GameSate.DayTransition;
                    DayTransitionManager.instance.InitDayTransition();
                    bear.GetComponent<Rigidbody>().velocity = Vector3.zero;
                }
            }
            bearTriggerObjective = false;
        }
    }

    public void ChangeGameState(GameSate newGameState) {
        m_GameState = newGameState;
    }

    private void OnPlayerTriggerEnterObjective(GameObject currObjective) {
        if(currObjective == TimeOfDayHandeler.Instance.Objective) {
            bearTriggerObjective = true;
            if(m_GameState == GameSate.GoEat) {
                PressButtonDisplay.instance.Enable("Eat");
            } else if(m_GameState == GameSate.GoSleep) {
                PressButtonDisplay.instance.Enable("Sleep");
            }
        }
    }

    private void OnPlayerTriggerExitObjective(GameObject currObjective) {
        if(currObjective == TimeOfDayHandeler.Instance.Objective) {
            bearTriggerObjective = false;
            PressButtonDisplay.instance.Disable();
        }
    }

    [ContextMenu("Win !")]
    public void WinGame() {
        float animDuration = 5f;
        m_GameState = GameSate.EndGame;
        Camera cam = Camera.main;
        Transform cameraTarget = cam.transform.parent;

        cam.farClipPlane = 5000;
        cameraTarget.transform.DODynamicLookAt(new Vector3(0, -500, 0), animDuration)
            .SetEase(Ease.InOutSine);
        cameraTarget.transform.DOLocalMoveZ(-3000f, animDuration)
            .SetEase(Ease.InOutCubic);

        if(maps != null) {
            foreach(GameObject map in maps) {
                map.transform.DOScale(0, animDuration / 2f)
                    .OnComplete(() => map.SetActive(false));
            }
        }
        a = true;
    }
}
