import Sound
import lean_certs.cert_29_114

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H29_gt_114_kernel : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 29) (d := 114) (c := cert_29_114) (by decide)
