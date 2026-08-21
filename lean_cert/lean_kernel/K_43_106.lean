import Sound
import lean_certs.cert_43_106

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_106_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 43) (d := 106) (c := cert_43_106) (by decide)
