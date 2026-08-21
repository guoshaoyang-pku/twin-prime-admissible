import Sound
import lean_certs.cert_50_122

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_122_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 50) (d := 122) (c := cert_50_122) (by decide)
