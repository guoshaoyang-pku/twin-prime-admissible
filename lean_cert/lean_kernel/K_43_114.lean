import Sound
import lean_certs.cert_43_114

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_114_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 43) (d := 114) (c := cert_43_114) (by decide)
