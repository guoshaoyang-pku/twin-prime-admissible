import Sound
import lean_certs.cert_29_122

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H29_gt_122_kernel : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 29) (d := 122) (c := cert_29_122) (by decide)
