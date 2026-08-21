import Sound
import lean_certs.cert_45_122

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_122_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 45) (d := 122) (c := cert_45_122) (by decide)
