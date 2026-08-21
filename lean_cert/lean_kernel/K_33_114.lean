import Sound
import lean_certs.cert_33_114

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H33_gt_114_kernel : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 33) (d := 114) (c := cert_33_114) (by decide)
