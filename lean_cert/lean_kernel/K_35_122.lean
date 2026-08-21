import Sound
import lean_certs.cert_35_122

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_122_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 35) (d := 122) (c := cert_35_122) (by decide)
