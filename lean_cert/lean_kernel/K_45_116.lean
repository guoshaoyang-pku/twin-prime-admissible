import Sound
import lean_certs.cert_45_116

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_116_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 45) (d := 116) (c := cert_45_116) (by decide)
