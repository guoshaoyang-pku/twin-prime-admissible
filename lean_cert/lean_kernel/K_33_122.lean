import Sound
import lean_certs.cert_33_122

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H33_gt_122_kernel : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 33) (d := 122) (c := cert_33_122) (by decide)
