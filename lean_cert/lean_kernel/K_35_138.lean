import Sound
import lean_certs.cert_35_138

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_138_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 35) (d := 138) (c := cert_35_138) (by decide)
