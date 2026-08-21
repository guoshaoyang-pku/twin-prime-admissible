import Sound
import lean_certs.cert_50_106

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_106_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 50) (d := 106) (c := cert_50_106) (by decide)
