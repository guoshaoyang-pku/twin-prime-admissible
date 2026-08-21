import Sound
import lean_certs.cert_27_106

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H27_gt_106_kernel : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 27) (d := 106) (c := cert_27_106) (by decide)
