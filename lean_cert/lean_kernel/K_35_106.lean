import Sound
import lean_certs.cert_35_106

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_106_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 35) (d := 106) (c := cert_35_106) (by decide)
