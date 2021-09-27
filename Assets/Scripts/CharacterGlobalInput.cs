using UnityEngine;
using UnityEngine.InputSystem;

namespace CMF {
    public class CharacterGlobalInput : CharacterInput {
        [SerializeField] private InputActionReference movementInputAxis, jumpInput, sprintInput;

        private void Awake() {
            jumpInput.action.performed += _ => isJumpKeyPressed = true;
            jumpInput.action.canceled += _ => isJumpKeyPressed = false;
            sprintInput.action.performed += _ => isSprintKeyPressed = true;
            sprintInput.action.canceled += _ => isSprintKeyPressed = false;
        }

        private void OnEnable() {
            movementInputAxis.action.Enable();
            jumpInput.action.Enable();
            sprintInput.action.Enable();
        }

        public override float GetHorizontalMovementInput() {
            return movementInputAxis.action.ReadValue<Vector2>().x;
        }

        public override float GetVerticalMovementInput() {
            return movementInputAxis.action.ReadValue<Vector2>().y;
        }
    }
}
