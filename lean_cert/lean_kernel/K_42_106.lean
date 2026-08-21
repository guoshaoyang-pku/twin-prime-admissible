import Sound
import lean_certs.cert_42_106

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_106_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 42) (d := 106) (c := cert_42_106) (by decide)
