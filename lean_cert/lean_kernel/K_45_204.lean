import Sound
import lean_certs.cert_45_204

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H45_gt_204_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 204 := by
  exact certValidRoot_sound (k := 45) (d := 204) (c := cert_45_204) (by decide)
