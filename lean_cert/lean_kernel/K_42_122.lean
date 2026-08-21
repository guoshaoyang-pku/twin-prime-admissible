import Sound
import lean_certs.cert_42_122

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_122_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 42) (d := 122) (c := cert_42_122) (by decide)
