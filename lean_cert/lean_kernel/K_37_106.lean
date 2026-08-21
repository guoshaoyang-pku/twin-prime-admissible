import Sound
import lean_certs.cert_37_106

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_106_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 37) (d := 106) (c := cert_37_106) (by decide)
