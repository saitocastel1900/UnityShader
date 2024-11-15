using UnityEngine;

public class BillBoard : MonoBehaviour
{
    [SerializeField] private Camera _playerCamera;
    [SerializeField] private Transform _billboardObjects;
    
    private void LateUpdate()
    {
        _billboardObjects.rotation = _playerCamera.transform.rotation;
    }
}
