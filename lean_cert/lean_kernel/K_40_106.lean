import Sound
import lean_certs.cert_40_106

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_106_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 40) (d := 106) (c := cert_40_106) (by decide)
