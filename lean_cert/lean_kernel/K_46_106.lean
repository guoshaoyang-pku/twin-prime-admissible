import Sound
import lean_certs.cert_46_106

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_106_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 46) (d := 106) (c := cert_46_106) (by decide)
