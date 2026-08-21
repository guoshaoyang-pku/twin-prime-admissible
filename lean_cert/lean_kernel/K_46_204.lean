import Sound
import lean_certs.cert_46_204

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H46_gt_204_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 204 := by
  exact certValidRoot_sound (k := 46) (d := 204) (c := cert_46_204) (by decide)
