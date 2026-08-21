import Sound
import lean_certs.cert_47_204

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H47_gt_204_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 204 := by
  exact certValidRoot_sound (k := 47) (d := 204) (c := cert_47_204) (by decide)
