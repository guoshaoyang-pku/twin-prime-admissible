import Sound
import lean_certs.cert_40_122

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_122_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 40) (d := 122) (c := cert_40_122) (by decide)
